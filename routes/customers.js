const express =  require('express');
const db = require('../db/database');

const router = express.Router();

/************************************* 
sample valid schema for post req json
{   
    "email":"afjkkk@b.com",
    "hash_":"123546"
}
 ***************************************/

router.post('/',async (req,res)=>{
    let data = req.body;
    data.userType = "customer";
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
	"customerId":"2",
	"customerType":"retailer",
	"firstName":"isuruul",
	"lastName":"ma",
	"city":"gampaha",
	"street":"jsjs",
	"num":"1",
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