function verificar(){
    // event.preventDefault();
    let username = document.getElementById('username_L').value;
    let password = document.getElementById('password_L').value;

    let xhr = new XMLHttpRequest();
    xhr.open('POST','/login', true);
    xhr.setRequestHeader('Content-Type', 'application/json');
    xhr.send(JSON.stringify({
        username: username,
        password: password
    }));

    xhr.onload = function() {
        if (xhr.status === 200) {
            let response = JSON.parse(xhr.responseText);
            if (response.success) {
                
                window.location.href = '/view/first_page';
            } else {
                alert('Invalid username or password');
            }
        } else {
            alert('Request failed.  Returned status of ' + xhr.status);
        }
    };
}


function Cadastrar()
{
    let nome = document.getElementById('nome_C').value;
    let username = document.getElementById('username_C').value;
    let password = document.getElementById('password_C').value;

    // mudar de local esse código !!
    let regex = /^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{8,}$/;
    if (!regex.test(password)) {
        alert('A senha deve conter pelo menos um caractere especial, um número e uma letra maiúscula.');
        return;
    }
    console.log(nome, username, password);
    let xhr = new XMLHttpRequest();
    xhr.open('POST', '/register', true);
    xhr.setRequestHeader('Content-Type', 'application/json');
    xhr.send(JSON.stringify({
        nome: nome,
        username: username,
        password: password
    }));

    xhr.onload = function() {
        if (xhr.status === 200) {
            let response = JSON.parse(xhr.responseText);
            if (response.success) {
                alert('Dados inseridos com sucesso!');
            } else {
                alert('Falha ao inserir dados');
            }
        } else {
            alert('Request failed.  Returned status of ' + xhr.status);
        }
    };
}

// function verificar() {
//     let username = document.getElementById('username_L').value;
//     let password = document.getElementById('password_L').value;
//     enviarDados('/login', { username: username, password: password });
// }

// function cadastrar() {
//     let nome = document.getElementById('nome_C').value;
//     let username = document.getElementById('username_C').value;
//     let password = document.getElementById('password_C').value;
//     enviarDados('/register', { nome: nome, username: username, password: password });
// }

// function enviarDados(url, data) {
//     let xhr = new XMLHttpRequest();
//     xhr.open('POST', url, true);
//     xhr.setRequestHeader('Content-Type', 'application/json');
//     xhr.send(JSON.stringify(data));

//     xhr.onload = function() {
//         if (xhr.status === 200) {
//             let response = JSON.parse(xhr.responseText);
//             if (response.success) {
//                 alert('Sucesso!');
//             } else {
//                 alert('Falha!');
//             }
//         } else {
//             alert('Request failed.  Returned status of ' + xhr.status);
//         }
//     };
// }
