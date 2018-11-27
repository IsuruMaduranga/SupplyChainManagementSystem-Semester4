const express =  require('express');
const morgan = require('morgan');



//import routes
const users = require('./routes/users');
const customers = require('./routes/customers');
const auth = require('./routes/auth');
const admins = require('./routes/admin');
const employees = require('./routes/employees');
const stores = require('./routes/stores');
const routes = require('./routes/routes');

const app =  express();

//middlewear
app.use(morgan('tiny'));
app.use(express.json());

//routing
app.use('/api/users',users);
app.use('/api/customers',customers);
app.use('/api/auth',auth);
app.use('/api/admins',admins);
app.use('/api/employees',employees);
app.use('/api/stores',stores);
app.use('/api/routes',routes);

app.listen(3000,()=>{
    console.log('server started on port 3000');
});


