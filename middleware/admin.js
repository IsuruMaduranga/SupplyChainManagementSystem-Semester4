
function admin(req,res,next){
    if(!req.user.userType==='admin') return res.status(403).send('Access denied!');
}

module.exports =  admin;