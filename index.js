const express =  require('express');
const morgan = require('morgan');



//import routes
const users = require('./routes/users');
const customers = require('./routes/customers');
const auth = require('./routes/auth');
const admin = require('./routes/admin');
const employee = require('./routes/employee');

const app =  express();

//middlewear
app.use(morgan('tiny'));
app.use(express.json());

//routing
app.use('/api/users',users);
app.use('/api/customers',customers);
app.use('/api/auth',auth);
app.use('/api/admin',admin);
app.use('/api/employee',employee);


app.listen(3000,()=>{
    console.log('server started on port 3000');
});


