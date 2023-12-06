// server.js
const express = require('express');
const { Pool } = require('pg');
const cors = require('cors');
const fs = require('fs');
const path = require('path');
const app = express();
const routher= express.Router();

//routher pesquisar 
routher.get('/', function(req, res ){
  res.sendFile(path.join(__dirname+'/view'));
})


app.use(express.json());
// lembrar de substituir pelo caminho onde está o meu projeto 

//servir os elementos staticos como css e js
app.use(express.static(path.join(__dirname))); 
//servir os elementos html
app.use(express.static(path.join(__dirname, 'ProjetoBD', 'html')));

app.use(cors());


const pool = new Pool({
  host: 'localhost', // o host do banco de dados
  user: 'postgres', // o username
  password: 'xadrez10', // a sua senha
  database: 'n2', // o nome do banco de dados
  port: 5432, // a porta do banco de dados
});

//requisição que executa meus scripts
app.get('/fetch', (req, res) => {
  const scriptName = req.query.script;
  fs.readFile(`./sql/${scriptName}`, 'utf8', (err, sql) => {
    if (err) {
      console.error(err);
      res.status(500).json({ error: 'Failed to load SQL script' });
      return;
    }

    pool.query(sql, (err, result) => {
      if (err) {
        console.error(err);
        res.status(500).json({ error: 'Failed to execute SQL script' });
        return;
      }

      // Adicione os nomes das colunas ao resultado
      const columns = sql.split('\n')[0].replace('-- ', '').split(',');
      res.json({ rows: result.rows, columns: columns });
    });
  });
});

//verificação de senha e usuário
app.post('/login', (req, res) => {

   const { username, password } = req.body;
   console.log(req.body);
   // Consulta SQL para verificar o nome de usuário e a senha
   const query = {
       text: 'SELECT * FROM tb_users WHERE username = $1 AND password = $2',
       values: [username, password],
   };

   pool.query(query, (err, result) => {
       if (err) {
           console.error(err);
           res.status(500).json({ success: false, message: 'Erro ao executar a consulta SQL' });
           return;
       }

       if (result.rows.length > 0) {
           // O nome de usuário e a senha estão corretos
           res.json({ success: true });
       } else {
           // O nome de usuário ou a senha estão incorretos
           res.json({ success: false, message: 'Nome de usuário ou senha incorretos' });
       }
   });
});

//Cadastrando
app.post('/register', (req, res) => {
  const { nome, username, password } = req.body;
  console.log(req.body);
  // Consulta SQL para inserir o nome, nome de usuário e senha
  const query = {
      text: 'INSERT INTO tb_users (nome, username, password) VALUES ($1, $2, $3)',
      values: [nome, username, password],
  };

  pool.query(query, (err, result) => {
      if (err) {
          console.error(err);
          res.status(500).json({ success: false, message: 'Erro ao executar ao INSERIR DADOS' });
          return;
      }

      // Dados inseridos com sucesso
      res.json({ success: true });
  });
});


app.listen(3000, () => {
  console.log('Server started on port 3000');
});
