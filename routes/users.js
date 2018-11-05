const express =  require('express');
const db = require('../db/database');

const router = express.Router();


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