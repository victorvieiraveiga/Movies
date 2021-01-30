# inChurch Recruitment Process 2021 - iOS Developer

###[Victor Vieira Veiga] (https://www.linkedin.com/in/victor-vieira-veiga-96867157)
[GitHub](https://github.com/victorvieiraveiga

)
* * *

## Arquitetura Utilizada

+ ### MVC - Model View Controller
	

	Utilizei arquitetura MVC por achar mais adequado para organizar o projeto.
	Criei ainda uma pasta Helpers onde inclui um arquivo para armazenar as constantes do projeto, como url's e alguns nomes de controles. 

* * *

## LIBS

Utilizei o [Realm](https://realm.io/) para realizar a persistencia dos dados dos filmes favoritados. utilizei essa biblioteca por achar a codificação mais simples e com mais performance que o CoreData. 

* * *

## Execução

* Executar prefenciamente no simulador do Iphone 11 ou 12.


* * *

## Sobre o Projeto

* TELA DE FILMES - Contem a Lista de Filmes carregadas da API, Exibindo Titulo, Poster e estrela de favorito.


![Alt text](images/imgMovies.png)
      

* TELA DE FAVORITOS -  Esta tela contem lista dos filmes favoritados pelo usuario. Caso esteja vazia exibe uma mensagem para o usuario.
BUSCA: Usuario tamnbem pode realizar buscas de filmes favoritados nessa tela. Caso a busca não retorne resultado uma mensagem é exibida para o usuario.
EXCLUSÃO: Nesta tela tambem é possivel excluir o filme da lista de favoritos, selecionado o filme e arrastando para a esquerda.

![Alt text](images/imgFavoritos.png) ![Alt text](images/img3Delete.png)  ![Alt text](images/imgBusca.png) 

* TELA DE DETALHES. Nesta tela os detalhes do filme selecionado na pagina principal são visualizados. Contem imagem em maior tamanho, Data de lançamento, Genero e sinopse do filme. Nesta tela é realizada a favoritação do filme clicando na estrela ao lado do titulo. 

 ![Alt text](images/imgDetalhes.png) 
* * *


* E-mail: victorvieiraveiga@gmail.com