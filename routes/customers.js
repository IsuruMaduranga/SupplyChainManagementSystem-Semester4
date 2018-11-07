const express =  require('express');
const db = require('../db/database');
const bcrypt = require('bcrypt');
const router = express.Router();
const uniqid = require('uniqid');

/************************************* 
sample valid schema for post req json
{   
    "email":"afjkkk@b.com",
    "_password":"123546"
}
 ***************************************/

router.post('/',async (req,res)=>{
    let data = req.body;
    data._type = "customer";

    //hashing password
    const salt = await bcrypt.genSalt(10);
    const hash = await bcrypt.hash(data._password,salt);
    data._password = hash;

    //generate uniqid
    data.user_id =  uniqid.process();

    let sql = 'INSERT INTO users SET ?';

    try{
        let result = await db.query(sql,data);
        res.send("account successfully created!");

    }catch(err){
        console.log(err);
        if(err.message==='Database connection error') return res.status(500).send(err);
        return res.status(400).send(err);
    }
    
});

/************************************* 
sample valid schema for post req json
{  
	"customer_id":"2",
	"_type":"retailer",
	"first_name":"isuruul",
    "last_name":"ma",
    "num":"1",
	"city":"gampaha",
	"street":"jsjs",
	"phone":"0778260669"
}
 ***************************************/


router.post('/account',async (req,res)=>{
    let data = req.body;
    let sql = 'INSERT INTO customers SET ?';

    try{
        let result = await db.query(sql,data);
        res.send("account successfully created!");

    }catch(err){
        if(err.message==='Database connection error') return res.status(500).send(err);
        return res.status(400).send(err);
    }
    
});

router.get('/',async (req,res)=>{
    let sql = 'SELECT * FROM customers';

    try{
        let result = await db.query(sql);
        res.send(result);

    }catch(err){
        if(err.message==='Database connection error') return res.status(500).send(err);
        return res.status(400).send(err);
    }
    
});


module.exports = router;