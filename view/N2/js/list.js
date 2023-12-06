function ExecutaScript() {
  $(document).ready(function () {
    let scriptName = $("#scriptSelect").val();
    if (scriptName != "all") {
      // Ocultar a div "loadingGif"
      document.getElementById('loadingGif').style.display = 'none';

      $.getJSON("http://localhost:3000/fetch?script=" + scriptName, function (data) {
        let items = [];

        // Cria a linha de cabeçalho
        let header = "<tr>";
        data.columns.forEach(column => {
          header += "<th><b>" + column.toUpperCase() + "</b></th>";
        });
        header += "</tr>";
        items.push(header);

        // Cria as linhas de dados
        $.each(data.rows, function (key, val) {
          items.push("<tr>");
          $.each(val, function (key, val) {
            items.push("<td>" + val + "</td>");
          });
          items.push("</tr>");
        });

        // Limpa a tabela antes de adicionar as novas linhas
        $("#tabelaDados").empty();
        document.getElementById('tabelaDiv').scrollTop = 0;

        // Adiciona a linha de cabeçalho e as linhas de dados à tabela
        $("<thead/>", { html: items.join("") }).appendTo("#tabelaDados");
      });
    }
  });
}

function LimpaLista() {
  $("#tabelaDados").empty();
  document.getElementById('tabelaDiv').scrollTop = 0;
  document.getElementById('loadingGif').style.display = 'block';
}


function Pesquisa() {
  let input, filter, table, tr, td, i, j, txtValue;
  input = document.getElementById("myInput");
  filter = input.value.toUpperCase();
  table = document.getElementById("tabelaDados");
  tr = table.getElementsByTagName("tr");
  for (i = 0; i < tr.length; i++) {
    td = tr[i].getElementsByTagName("td");
    for (j = 0; j < td.length; j++) {
      if (td[j]) {
        txtValue = td[j].textContent || td[j].innerText;
        if (txtValue.toUpperCase().indexOf(filter) > -1) {
          tr[i].style.display = "";
          break;
        } else {
          tr[i].style.display = "none";
        }
      }
    }
  }
}
