const express =  require('express');
const db = require('../db/database');

const router = express.Router();

/********************************
sample valid schema for post req json 
    {
        "store":"colombo",
        "max_time_hours":"2",
        "route_path":"town1,town2,town3"
    }
 ******************************/

router.post('/',async (req,res)=>{
    let data = req.body;

    let sql = 'INSERT INTO routes SET ?';

    try{
        let result = await db.query(sql,data);
        res.send(result);

    }catch(err){
        if(err.message==='Database connection error') return res.status(500).send(err);
        return res.status(400).send(err);
    }
     
});

router.get('/',async (req,res)=>{

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