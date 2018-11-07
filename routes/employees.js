const express =  require('express');
const db = require('../db/database');
const bcrypt = require('bcrypt');
const router = express.Router();
const uniqid = require('uniqid');
const _ = require('lodash');

/************************************* 
sample valid schema for post req json
{  
    "email" : "b@k.com"
	"_password" : "325637"
	"_type":"driver",
	"first_name":"isuruul",
    "last_name":"ma",
    "phone":"0778260669",
    "salary":"100",
}
 ***************************************/

router.post('/',async (req,res)=>{
    let data = req.body;

    //hashing password
    const salt = await bcrypt.genSalt(10);
    const hash = await bcrypt.hash(data._password,salt);
    data._password = hash;

    //generate uniqid
    data.user_id =  uniqid.process();

    let sql1 = 'INSERT INTO users SET ?';
    let data1 = _.pick(data,['user_id','email','_password']);
    data1._type = 'employee';

    let sql2 = 'INSERT INTO employees SET ?';
    let data2 = _.pick(data,['_type','first_name','last_name','phone','salary']);
    data2.employee_id = data.user_id;

    try{
        let result = await db.trans_2(sql1,data1,sql2,data2);
        res.send(result);

    }catch(err){
        if(err.message==='Database connection error' || err.message==='Error') return res.status(500).send(err);
        return res.status(400).send(err);
    }
});



router.get('/',async (req,res)=>{
    let sql = 'SELECT * FROM employees';

    try{
        let result = await db.query(sql);
        res.send(result);

    }catch(err){
        if(err.message==='Database connection error') return res.status(500).send(err);
        return res.status(400).send(err);
    }
    
});


module.exports = router;