const express = require('express');
const mysql = require('mysql2');
const morgan = require('morgan');
// Directs to .env file configured as ./sqlConfig.env
require('dotenv').config({ path: './sqlConfig.env' });
const PORT = 3000;

const app = express();
// Different parsers
app.use(express.json());
app.use(express.urlencoded({ extended: true }));
// Morgan will log requests in dev format (method, URL, status, response time) are logged
app.use(morgan('dev'));

// Connecting to SQL database
const pool = mysql.createPool({
    host: process.env.DB_HOST,
    user: process.env.DB_USER,
    password: process.env.DB_PASSWORD,
    database: process.env.DB_NAME,
    waitForConnections: true,
    connectionLimit: 10,
    queueLimit: 0
});

// Check connections
// Check the server is running
app.listen(PORT, () => {
    console.log(`Server is running on port ${PORT}`);
});
// Check if your .env file is reading correctly
console.log('HOST: ', process.env.DB_HOST, 'USER: ', process.env.DB_USER, 'PASSWORD: ', process.env.DB_PASSWORD)
//Check the SQL database is connected
pool.getConnection((err, connection) => {
    if (err) {
        console.error('Error connecting to the database:', err.message);
        throw err;  // Stop execution if the connection fails
    } else {
        console.log("Database connected!");
        connection.release();  // Release the connection
    }
});

// Establishing routes/ Setting up requests
// Function to generate HTML table // Hardcoded CSS - Could be in another file but in interest of time it's here
const generateTableHTML = (headers, rows, title = 'List of Events') => {
    let html = `
        <!DOCTYPE html>
        <html lang="en">
        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <title>${title}</title>
            <style>
                body {
                    font-family: Arial, sans-serif;
                    margin: 0;
                    padding: 20px;
                    background-color: #f4f4f9;
                }
                table {
                    width: 80%;
                    margin: 20px auto;
                    border-collapse: collapse;
                }
                table, th, td {
                    border: 1px solid black;
                }
                th, td {
                    padding: 10px;
                    text-align: left;
                }
                th {
                    background-color: #f2f2f2;
                }
                h1 {
                    text-align: center;
                    color: #333;
                }
            </style>
        </head>
        <body>
            <h1>${title}</h1>
            <table>
                <thead>
                    <tr>${headers.map(h => `<th>${h}</th>`).join('')}</tr>
                </thead>
                <tbody>
                    ${rows.map(row => `
                        <tr>${Object.values(row).map(value => `<td>${value}</td>`).join('')}</tr>
                    `).join('')}
                </tbody>
            </table>
        </body>
        </html>
    `;
    return html;
};
// Get request - endpoint 1 - See currently booked events
app.get('/events', (req,res) => {
    const query = 'SELECT * FROM Events';

    pool.query(query, (err, results) => {
        if (err) {
            console.error('Error fetching the booked events', err.message);
            return res.status(500).json({error: err.message});
        }
        // res.status(200).json(results); << This would output 200 0K status & sends list of results in json array
        // HTML Response so you see it in the page in your browser
        const html = generateTableHTML(
            ['Event ID', 'Room', 'Event Date', 'Occasion', 'Room Capacity', 'Number Of Guests'], 
            results,
            'List of Events'
        );
        res.status(200).send(html);
    });
});

// Post request - endpoint 2 - Make a request for an event
// The form action tag triggers the next endpoint when the user clicks 'Submit Request'
app.get('/make-a-request', (req, res) => {
    // Send an HTML form as the response
    const formHtml = `
    <!DOCTYPE html>
    <html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Submit an Event Request</title>
    </head>
    <body>
        <h1>Submit Your Event Request</h1>
        <form action="/request-sent" method="POST">
            <label for="EventDate">Event Date:</label><br>
            <input type="date" id="EventDate" name="EventDate" required><br><br>

            <label for="CustomerName">Customer Name:</label><br>
            <input type="text" id="CustomerName" name="CustomerName" required><br><br>

            <label for="MobileNumber">Mobile Number:</label><br>
            <input type="text" id="MobileNumber" name="MobileNumber" required><br><br>

            <label for="Address">Customer Address:</label><br>
            <input type="text" id="Address" name="Address" required><br><br>

            <label for="Occasion">Occasion:</label><br>
            <input type="text" id="Occasion" name="Occasion" required><br><br>

            <label for="NumberOfGuests">Number of Guests:</label><br>
            <input type="number" id="NumberOfGuests" name="NumberOfGuests" required><br><br>

            <button type="submit">Submit Request</button>
        </form>
    </body>
    </html>
    `;
    // Send the HTML form as the response
    res.send(formHtml);
});

// Post request - endpoint 3 - Confirm the request has been made
app.post('/request-sent', (req, res) => {
    // Get the event data from the request body
    const { EventDate, CustomerName, MobileNumber, Address, Occasion, NumberOfGuests} = req.body;

    // Input Validation: Check if inputs match what the SQL database is expecting
    // Manually done in interest of time but there is middleware to do this
    // Check if all required fields are provided
    if (!EventDate || !CustomerName || !MobileNumber || !Address || !Occasion || !NumberOfGuests) {
        return res.status(400).json({ error: 'Please fill in all the fields' });
    }

    // Validate EventDate (should be a valid date and not in the past)
    // Put it in date type
    const eventDateObj = new Date(EventDate);
    const currentDate = new Date();
    // If the entered data is invalid, it's flagged as Not a Number
    if (isNaN(eventDateObj.getTime()) || eventDateObj < currentDate) {
        return res.status(400).json({ error: 'Event Date must be a valid future date' });
    }

    // Validate CustomerName (non-empty string, max length 50)
    if (typeof CustomerName !== 'string' || CustomerName.length > 50) {
        return res.status(400).json({ error: 'Customer Name has a maximum length of 50 characters' });
    }

    // Validate MobileNumber (valid phone number format, max length 20)
    // Could also add regex to make it follow a certain format but these are magical phone numbers so left out
    if (MobileNumber.length > 20) {
        return res.status(400).json({ error: 'Mobile Number has a maximum length of 20 characters' });
    }

    // 4. Validate Address (non-empty string, max length 255)
    if (typeof Address !== 'string' || Address.length > 100) {
        return res.status(400).json({ error: 'Address has a maximum length of 100 characters' });
    }

    // Validate Occasion (non-empty string, max length 50)
    if (typeof Occasion !== 'string' || Occasion.length > 50) {
        return res.status(400).json({ error: 'Occasion has a maximum length of 50 characters' });
    }

    // Validate NumberOfGuests (must be an integer and a positive number)
    if (!Number.isInteger(Number(NumberOfGuests)) || NumberOfGuests <= 0) {
        return res.status(400).json({ error: 'Number Of Guests must be a positive integer' });
    }

    // SQL query to insert the event into the database
    const query = 'INSERT INTO Requests (EventDate, CustomerName, MobileNumber, Address, Occasion, NumberOfGuests) VALUES ( ?, ?, ?, ?, ?, ?)';

    // Execute the query with the user's input
    pool.query(query, [EventDate, CustomerName, MobileNumber, Address, Occasion, NumberOfGuests], (err, result) => {
        if (err) {
            console.error('Error creating event:', err.message);
            return res.status(500).json({ error: 'Failed to create event' });
        }
        // Respond with a success message and the new event ID
        return res.status(201).json({ message: 'Event created successfully'});
    });
});

// Get Request - endpoint 4 - additional endpoint - Get all event requests that have been made by a customer
app.get('/customer-requests/:CustomerName', (req,res) => {
    const rawName = req.params.CustomerName // Extracts CustomerName entered in the URL
    // The URL does not allow for spaces so we want to reformat the Name like how it was entered
    const formattedName = rawName.replace(/([a-z])([A-Z])/g, '$1 $2');
    // Now 'DracoMalfoy' will become 'Draco Malfoy'
    console.log(`Formatted Customer Name: ${formattedName}`);

    const query = 'SELECT * FROM Requests WHERE CustomerName = ?';

    pool.query(query, [formattedName], (err, results) => {
        if (err){
            console.error('Error retrieving the request', err.message);
            return res.status(500).json({error: err.message});
        } else if (results.length === 0) {
            return res.status(404).json({message: 'There are no requests found from this customer'});
        }
        else {
            const html = generateTableHTML(
                ['Event Date', 'Customer Name', 'Mobile Number', 'Address', 'Occasion', 'Number Of Guests', 'Dealt With'],
                results,
                'List of Requests'
            )
            res.status(200).send(html);
        };
    });
});

// Bonus endpoint to see your added requests - endpoint 5 - Displays the Requests table from the database
app.get('/requests', (req,res) => {
    const query = 'SELECT * FROM Requests';

    pool.query(query, (err, results) => {
        if (err) {
            console.error('Error fetching the submitted requests', err.message);
            return res.status(500).json({error: err.message});
        }
        // HTML Response so you see it in the page in your browser
        const html = generateTableHTML(
            ['Event Date', 'Customer Name', 'Mobile Number', 'Address', 'Occasion', 'Number Of Guests', 'Dealt With'],
            results,
            'List of Requests'
        );
        res.status(200).send(html);
    });
});