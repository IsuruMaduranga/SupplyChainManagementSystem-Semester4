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

function trans_2(sql1,data1,sql2,data2){
    return new Promise((resolve,reject)=>{
        pool.getConnection((err,connection)=>{
            if(err) return reject('Database connection error');
        
            connection.beginTransaction(err=>{
                if(err){
                    connection.rollback(()=>{
                        connection.release();
                    });
                    reject('Error');
                    return;
                }
    
                connection.query(sql1,data1,(err,result)=>{
                    if(err){
                        connection.rollback(()=>{
                            connection.release();
                        });
                        reject('Error');
                        return;
                    }
    
                    connection.query(sql2,data2,(err,result)=>{
                        if(err){
                            connection.rollback(()=>{
                                connection.release();
                            });
                            reject('Error');
                            return;
                        }
                        
                        connection.commit((err)=>{
                            if (err) {
                                connection.rollback(function() {
                                    connection.release();
                                });
                                reject('Error');
                                return;
                            }   
                                connection.release();
                        });
        
                        resolve(result);
                    });
        
        
                });
    
            });
        });
    });
    
}

module.exports = {query:query,pool:pool,trans_2:trans_2};