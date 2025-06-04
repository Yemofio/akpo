// Will trigger our rules
const token = jwt.sign({ user: 'admin' }, 'insecure-secret-123');
eval(req.body.code);