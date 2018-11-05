const express =  require('express');
const db = require('../db/database');
const bcrypt = require('bcrypt');

const router = express.Router();

/********************************
sample valid schema for post ree json 
    {
        "userType":"admin",
        "email":"afjkkk@b.com",
        "hash_":"123546"
    }
 ******************************/

router.post('/',async (req,res)=>{
    let data = req.body;

    //hashing password
    const salt = await bcrypt.genSalt(10);
    const hash = await bcrypt.hash(data.hash_,salt);
    data.hash_ = hash;

    let sql = 'INSERT INTO users SET ?';

    try{
        let result = await db.query(sql,data);
        res.send("account successfully created!");

    }catch(err){
        if(err.message==='Database connection error') return res.status(500).send(err);
        return res.status(400).send(err);
    }
     
});

router.get('/',async (req,res)=>{

    let sql = 'SELECT userId,email,userType FROM users';

    try{
        let result = await db.query(sql);
        res.send(result);

    }catch(err){
        console.log(err)
        if(err.message==='Database connection error') return res.status(500).send(err);
        return res.status(400).send(err);
    }

});

module.exports = router;