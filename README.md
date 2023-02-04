# vakinha_burguer

Projeto Flutter - Vakinha Burger

## Getting Started

Projeto de delivery desenvolvido pelo Rodrigo Rahman no evento DartWeek 9, o propósito do app é o usuário fazer compras de
 lanches escolhendo quais lanches quiser e ir adicionando a sacola, isso sem precisar ter feito login. Mas ao clicar na sacola é redirecionado para a tela de login e cadastro onde poderá criar sua conta. Com sua conta criada é redirecionado para a tela de pedidos que contém todos os produtos adicionados, preços totais podendo adicionar mais ou retirar e até excluir. Mais a baixo contém alguns dados para entrega como endereço, cpf e tipo de pagamento clicando em finalizar o pedido é armazenado no backend e redirecionado para a tela de sucesso confirmando seu pedido.  O app utiliza a arquitetura MVC, para a gerência de estado é usado o Bloc e Provider e banco de dados local json_rest_server.

Aula 1  
- Preparando e subindo o backend;
- Instalando e configurando imagens e fontes do projeto;
- Configuração de todo o tema do projeto;
- Preparação das extensions de UI;
- Preparação do ButtonStyles (Botão Personalizado), para evitar repetição de código,
- Preparação Core da aplicação;
- Utilização do pacote flutter_dotenev para configurar a variável de ambiente;
- Configuração do RestClient utilizando o Dio;
- Para manter o código mais limpo, utilização de helpers para obter o tamanho da tela;

Aula 2
- Criação da Splash Page;
- Configuração da classe de modelo;
- Utilização do conceito repository pattern para buscar produtos;
- Criação e implementação da tela Home Page;
- Estruturação do projeto para trabalhar com bloc;
- Link entre controller e repository;
- Criação do BaseState;

Aula 3
- Criação da tela detalhe produto;
- Criação botão increment e decrement;
- Adicionando produtos no carrinho;
- Atualização na quantidade de produtos e regras de negócio;
