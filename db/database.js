const mysql = require('mysql');

const pool =  mysql.createPool({
    connectionLimit : 10,
    host: "localhost",
    user: 'root',
    password: 'root',
    database: 'SCMS'
});

function query(sql,data){
    return new Promise((resolve,reject)=>{
        pool.getConnection((err,con)=>{
            if(err) reject('Database connection error');

            con.query(sql,data,(err,result,fields)=>{
                if(err){
                    con.release();
                    reject(err);
                    return;
                } 
                con.release();
                resolve(result);
            });
        });
    });
};

module.exports = {query:query,pool:pool};