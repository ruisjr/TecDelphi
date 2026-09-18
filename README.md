# TecDelphi

Este é uma aplicação demonstrativa para tela de pedidos utilizando padrões de projetos, programação orientada a objetos, MVC e outros.

Instruções de instalação:

1 - Criar as seguintes pastas no windows com os nomes:
1.1 - C:\TecDelphi
1.2 - C:\TecDelphi\bin
1.3 - C:\TecDelphi\lib
1.4 - C:\TecDelphi\db

2 - Obrigatório a instalação do banco de dados Firebird na versão 5 x64;

3 - Para uma instalação do zero, é necessário criar o banco de dados: 
3.1 - Com o prompt do Firebird execute o comando: CREATE DATABASE 'C:\TecDelphi\db\Nome_do_Banco.FDB'
USER 'SYSDBA' PASSWORD 'masterkey';
3.2 - O banco de dados deve ser criado dentro da pasta C:\TecDelphi\db.

4 - Na pasta C:\TecDelphi\lib, copie a dll fbclient.dll contida neste repositório na pasta lib;

5 - As configurações acima são obrigatórias para o bom funcionamento e configuração da aplicação.

6- O arquivo de configuração para conexão com o banco de dados FDConnectionDefs.ini deverá ser copiado para a pasta C:\TecDelphi\bin.

Observações:

O arquivo FDConnectionDefs.ini deverá ser editado de acordo com as configurações a serem utilizadas pela aplicação, garantindo segurança e desempenho.
A chave [TecDelphi] não poderá em hipótese alguma ser mudada, pois a aplicação não funcionará.

Exemplo:

[TecDelphi]
DriverID=FB
ApplicationName=TecDelphi
Port=3050
Server=localhost
Database=C:\TecDelphi\db\TEST.FDB
User_Name=sysdba
Password=masterkey
CharacterSet=UTF8
Timeout=60
Protocol=TCPIP
VendorLib=C:\TecDelphi\lib\fbclient.dll
