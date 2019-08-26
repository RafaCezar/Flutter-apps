import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(
    home: HomePage(), 
    debugShowCheckedModeBanner: false, //? Tira o debbug da tela
  )); //? Roda o aplicativo
}

//? Digitar "stf" dar tab e preencher o nome da class (sem mexer em nada)

class Pessoa{
  double weight;
  double height;
  int groupValue;

  Pessoa(this.weight, this.height, this.groupValue);
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  var _keyForm = GlobalKey<FormState>(); //! PARA QUE SERVE ESSA PORRA ?

  int groupValue;
  void mudarRadio(int valor){
    setState(() {
     if (valor == 1) {
       groupValue = 1;
     } else if (valor == 2) {
       groupValue	= 2;
     }
    });
  }

  void _resetFields(){ //? Função que limpa o campo
    _heightController.clear(); //? Limpa o valor do controlador
    _weightController.clear();
    setState(() { //? Utiliza state para mudar o valor da variavel, pois ela não é uma variavel do controler
      _result = "Informe os dados";
      cor = Colors.black;
    });
  }

  @override //? Quando o aplicativo inicia, ele pega o estado inicial das variaveis, no caso este estado é a função _resetFields que ja define tudo como limpo
  void initState(){
    super.initState();
    _resetFields();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.teal[900], //? Muda a cor da AppBar
        title: Text("Calculadora de IMC"), //? Passa um texto para a AppBar
        actions: <Widget>[ //? Cria uma ação na barra
          IconButton( //? Cria um icone como se fosse um botão
            icon: Icon(Icons.refresh), //? Cria um icone padrão do android (Icons.refresh)
            onPressed: (){
              _resetFields(); //? Chama a função que limpa os textos
            },
          )
        ],
        //? Se fosse colocar o texto no meio da AppBar: centerTitle: true, 
      ),
      body: SingleChildScrollView( //? Faz com que na hora que abrir o texto para digitar, o componente suba junto com a tela para o teclado não ficar em cima
        child: buildContainer(), //? Metodo criado abaixo "Container buildContainer()"
      ),
    );
  }

  Widget buildContainer() {
    return Form( //? Para usar o validator precisa que os campos estejam dentro do form, por isso a criação do Form
      key: _keyForm, //! PARA QUE SERVE ESSA PORRA ?
      child: Container(
      padding: EdgeInsets.all(20.0), //? Padding em todos os filhos do container
      child: Column( //? Coluna pode receber mais de um filho, apenas Collumn / Row / Stack podem fazer isto
        crossAxisAlignment: CrossAxisAlignment.stretch, //? Faz com que o alinhamento de todos os filhos sejam estentedidos
        children: <Widget>[
          buildTextFormField( //? Campo de texto para peso
            label: "Peso (Kg)",
            error: "Digite um peso em quilograma",
            controller: _weightController), //? Metodo criado abaixo "TextFormField buildTextFormField" que passa como parametro o label a ser utilizado o erro a ser exibido e a variavel de controle a ser salvo os dados que forem digitados
          buildTextFormField( //? Campo de texto para altura
            label: "Altura (Cm)",
            error: "Digite uma altura em centimetros",
            controller: _heightController),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Radio(
                onChanged: (int valor) => mudarRadio(valor),
                activeColor: Colors.blue,
                value: 1,
                groupValue: groupValue,
              ),
              Text(
                "Masculino"
              ),
              Radio(
                onChanged: (int valor) => mudarRadio(valor),
                activeColor: Colors.pink,
                value: 2,
                groupValue: groupValue,
              ),
              Text(
                "Feminino"
              ),
            ],
          ),
          Padding( //? Campo de texto para resultado do IMC (Dentro de padding para ter espaçamento dos outros elementos)
            padding: const EdgeInsets.only(top: 10.0), //? Aplica um padding somente de top
            child: Center(
              child: Text(
                _result,
                textAlign: TextAlign.center, //? Alinha o texto do resultado do IMC
                style: TextStyle( //? Muda o estilo do texto do resultado do IMC
                  fontSize: 24.0,    
                  color: cor,        
                  fontWeight: FontWeight.bold)),
            ), //? Retorna um texto com a variavel calculada do IMC (função calculateImc)
          ),
          Padding( //? Como se fosse um container para o botão criado abaixo
            padding: const EdgeInsets.symmetric(vertical: 20.0), //? Padding criado simetricamente e vertical para o botão
            child: RaisedButton( //? Botão criado com background
              onPressed: () { //? Quando apertado botão
                if (_keyForm.currentState.validate()){ //? Caso não volte nem erro (esteja validado) retorna a função de calcualr, senam volta erro passado
                  calculateImc();
                }
              },
              color: Colors.teal[900],
              child: Text("Calcular"), //? Nome do botão
              textColor: Colors.white,
            ),
          ) //? Função para quando o botao for clicado
        ],
      ),
    ),
    );
  }

  TextEditingController _weightController = TextEditingController(); //? Função que salva na variavel privada o texto digitado pelo usuario dentro de buildTextFormField
  TextEditingController _heightController = TextEditingController();
  
  Widget buildTextFormField({String label, String error, TextEditingController controller}) { //? Metodo criado que tem como parametro um controlador e uma label e mensagem do erro a ser exibido
    return Padding(
      padding: const EdgeInsets.only(bottom: 10.0),
      child: TextFormField(
            controller: controller,
            keyboardType: TextInputType.number, //? Define o tipo de teclado que deve abrir ao clicar no TextFormField
            decoration: InputDecoration(
              labelText: label,
              labelStyle: TextStyle(fontSize: 18, color: Colors.black),
              //! Parte comentada abaixo serve para mudar a cor das bordas e tamanhos dela e o tipo dela
               focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(width: 1.5),
                ),
              enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.black), 
                ), 
             ), //? label do textInput a ser passada
            validator: (text) {
              return text.isEmpty ? error : null;
            }, //? Validação do campo input se o texto estiver vazio ele retorna vazio, senam ele retorna o erro a ser passado na função "buildTextFormField"
          ),
    );
  }

  String _result = "";
  Color cor;

  void calculateImc(){ //? Funçao que calcula IMC com os dados digitados pelo usuario
    Pessoa pessoa = new Pessoa(double.parse(_weightController.text), double.parse(_heightController.text)/100.0, groupValue);
    double imc = pessoa.weight / (pessoa.height * pessoa.height); //? Formula que calcula o IMC

    setState(() { //? Altera o estado da variavel
       _result = "IMC = ${imc.toStringAsFixed(2)}\n";
       
       if (groupValue == 1) {
        if (imc < 20.7) {
          _result += "Abaixo do peso"; //? Concatena com o resultado do IMC de acordo com o valor
          cor =  Colors.blue;
        }
        else if (imc < 26.4) {
          _result += "Peso ideal";
          cor = Colors.green;
        }
        else if (imc < 27.8) {
          _result += "Pouco acima do peso";
          cor = Colors.yellow;
        }
        else if (imc < 31.1) {
          _result += "Acima do peso";
          cor = Colors.orange;
        }
        else {
          _result += "Obesidade";
          cor = Colors.red;
        }
       } else if (groupValue == 2) {
          if (imc < 19.1) {
          _result += "Abaixo do peso"; //? Concatena com o resultado do IMC de acordo com o valor
          cor =  Colors.blue;
        }
        else if (imc < 25.8) {
          _result += "Peso ideal";
          cor = Colors.green;
        }
        else if (imc < 27.3) {
          _result += "Pouco acima do peso";
          cor = Colors.yellow;
        }
        else if (imc < 32.3) {
          _result += "Acima do peso";
          cor = Colors.orange;
        }
        else {
          _result += "Obesidade";
          cor = Colors.red;
        }
       }
    });
  }
}
