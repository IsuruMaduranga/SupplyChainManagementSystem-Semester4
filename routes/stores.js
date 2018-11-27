const express =  require('express');
const db = require('../db/database');

const router = express.Router();

/********************************
sample valid schema for post req json 
    {
        "city":"colombo",
        "contact_no":"0123456789"
    }
 ******************************/

router.post('/',async (req,res)=>{
    let data = req.body;

    let sql = 'INSERT INTO stores SET ?';

    try{
        let result = await db.query(sql,data);
        res.send(result);

    }catch(err){
        if(err.message==='Database connection error') return res.status(500).send(err);
        return res.status(400).send(err);
    }
     
});

router.get('/',async (req,res)=>{

    let sql = 'SELECT * FROM stores';

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