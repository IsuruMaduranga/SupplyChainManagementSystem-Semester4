const express =  require('express');
const db = require('../db/database');
const bcrypt = require('bcrypt');
const jwt = require('jsonwebtoken');
const _ = require('lodash');

const router = express.Router();

/********************************
sample valid schema for post ree json 
    {
        "email":"afjkkk@b.com",
        "hash_":"123546"
    }
 ******************************/

router.post('/',async (req,res)=>{

    let sql = 'SELECT * FROM users WHERE users.email=?';
    let data = req.body.email;

    try{
        let result = await db.query(sql,data);

        const isValid = await bcrypt.compare(req.body.hash_,result[0].hash_);

        if(!isValid) return res.status(400).send('Invalid email or password!');

        const token = jwt.sign(_.pick(result[0],['userId','email','userType']),'privateKey');
        res.send(token);

    }catch(err){
        if(err.message==='Database connection error') return res.status(500).send(err);
        return res.status(400).send(err);
    }
    
});


module.exports = router;


// db.getConnection((err,con)=>{
//     if(err) return res.send('Database connection error');

//     let sql = 'SELECT * FROM users WHERE users.email=?';

//     con.query(sql,req.body.email,(err,result,fields)=>{
//         if(err){
//             console.log(err);
//             return res.status(400).send(err);
//         }
        
//         (async (hash)=>{
//             const isValid = await bcrypt.compare(req.body.hash_,hash);
//             if(!isValid) return res.status(400).send('Invalid email or password!');

//             const token = jwt.sign(_.pick(result[0],['userId','email','userType']),'privateKey');
//             res.send(token);
             
//         })(result[0].hash_);

//     });