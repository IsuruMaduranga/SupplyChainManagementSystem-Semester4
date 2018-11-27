const express =  require('express');
const db = require('../db/database');
const bcrypt = require('bcrypt');
const router = express.Router();
const uniqid = require('uniqid');
const _ = require('lodash');

/************************************* 
sample valid schema for post req json
{   
    "email":"afjkkk@b.com",
    "_password":"123546"
    "cus_type":"retailer",
	"first_name":"isuruul",
    "last_name":"ma",
    "num":"1",
	"city":"gampaha",
	"street":"jsjs",
	"phone":"0778260669"
}
 ***************************************/

router.post('/',async (req,res)=>{
    let data1 = _.pick(req.body,["email","_password"]);
    data1._type = "customer";

    //hashing password
    const salt = await bcrypt.genSalt(10);
    const hash = await bcrypt.hash(data1._password,salt);
    data1._password = hash;

    //generate uniqid
    let id =  uniqid.process();

    data1.user_id = id;

    let sql1 = 'INSERT INTO users SET ?';

    let data2 = _.pick(req.body,['cus_type','first_name','last_name','num','city','street','phone']);
    data2.customer_id = id;

    let sql2 = 'INSERT INTO customers SET ?';

    try{
        let result = await db.trans_2(sql1,data1,sql2,data2);
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
	"cus_type":"retailer",
	"first_name":"isuruul",
    "last_name":"ma",
    "num":"1",
	"city":"gampaha",
	"street":"jsjs",
	"phone":"0778260669"
}
 ***************************************/


// router.post('/account',async (req,res)=>{
//     let data = req.body;
//     let sql = 'INSERT INTO customers SET ?';

//     try{
//         let result = await db.query(sql,data);
//         res.send("account successfully created!");

//     }catch(err){
//         if(err.message==='Database connection error') return res.status(500).send(err);
//         return res.status(400).send(err);
//     }
    
// });

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