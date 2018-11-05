const express =  require('express');
const {db} = require('../db/database');
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

    db.getConnection((err,con)=>{
        if(err) return res.status(500).send('Database connection error');

        let sql = 'INSERT INTO users SET ?';
        con.query(sql,data,(err,result,fields)=>{ 
            if(err){
                console.log(err);
                res.status(400).send(err);
                return;
            }
            res.send("account successfully created!");
        });
        
        con.release();
    });  
});

router.get('/',async (req,res)=>{
    db.getConnection((err,con)=>{
        if(err) return res.status(500).send('Database connection error');

        let sql = 'SELECT userId,email,userType FROM users';
        con.query(sql,(err,result,fields)=>{
            if(err){
                console.log(err);
                res.status(400).send(err);
                return;
            }
            res.send(result);
        });   
        
        con.release();
    });  
});

module.exports = router;