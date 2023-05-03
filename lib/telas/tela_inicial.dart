import 'dart:convert';
import 'dart:js_util';

import 'package:api_meteorologia/componentes/colocar_botao.dart';
import 'package:api_meteorologia/componentes/colocar_campo_texto.dart';
import 'package:api_meteorologia/componentes/colocar_texto.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:http/http.dart';

class TelaInicial extends StatefulWidget {
  const TelaInicial({super.key});

  @override
  State<TelaInicial> createState() => _TelaInicialState();
}

class _TelaInicialState extends State<TelaInicial> {
  final _formKey = GlobalKey<FormState>();
  final _txtCep = TextEditingController();
  //final _txtCidade = TextEditingController();

  String cidade = '_______';
  String data = '_______';
  String hora = '_______';
  String temp = '_______';
  String desc = '_______';
  String uf = '';

  viaCep() async {
    final String urlViaCep = 'https://viacep.com.br/ws/${_txtCep.text}/json/';
    Response resp = await get(Uri.parse(urlViaCep));
    Map cep = json.decode(resp.body);
    cidade = cep['localidade'];
    uf = cep['uf'];
    final String urlHgTemp =
        'https://api.hgbrasil.com/weather?format=json-cors&key=fcbea2bd&city_name$cidade,$uf';
    Response respTemp = await get(Uri.parse(urlHgTemp));
    Map hgTemp = json.decode(respTemp.body);
    setState(() {
      cidade;
      uf;
      data = '${hgTemp['results']['date']}';
      hora = '${hgTemp['results']['time']}';
      temp = '${hgTemp['results']['temp']}';
      desc = '${hgTemp['results']['description']}';
    });
  }

  hgTemp() async {
    final String urlHgTemp =
        'https://api.hgbrasil.com/weather?format=json-cors&key=fcbea2bd&city_name$cidade,$uf';
    Response resp = await get(Uri.parse(urlHgTemp));
    Map hgTemp = json.decode(resp.body);
    viaCep();
    setState(() {
      data = hgTemp['results']['date'];
      hora = hgTemp['results']['time'];
      temp = hgTemp['results']['temp'];
      desc = hgTemp['results']['description'];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Previsão do Tempo',
          style: TextStyle(
            fontSize: 30,
            color: Colors.black,
          ),
        ),
        centerTitle: true,
      ),
      body: Form(
        key: _formKey,
        child: Column(
          children: [
            Row(
              children: [
                const Expanded(child: ColocarTexto(texto: 'CEP: ')),
                Expanded(
                    child: CampoDeTexto(
                  controlador: _txtCep,
                  msgVal: 'Por favor, informe um CEP.',
                  texto: 'CEP',
                )),
                Expanded(
                    child: Botao(
                  corFonte: Colors.white,
                  corFundo: Colors.blue,
                  funcao: viaCep,
                  texto: 'OK',
                ))
              ],
            ),
            Row(
              children: [
                Expanded(
                  child: Column(
                    children: [
                      Row(
                        children: [
                          const ColocarTexto(texto: 'Cidade: '),
                          ColocarTexto(texto: cidade),
                        ],
                      ),
                      Row(
                        children: [
                          const ColocarTexto(texto: 'Data: '),
                          ColocarTexto(texto: data),
                        ],
                      ),
                      Row(
                        children: [
                          const ColocarTexto(texto: 'Hora: '),
                          ColocarTexto(texto: hora),
                        ],
                      ),
                      Row(
                        children: [
                          const ColocarTexto(texto: 'Temperatura: '),
                          ColocarTexto(texto: temp),
                        ],
                      ),
                      Row(
                        children: [
                          const ColocarTexto(texto: 'Descrição: '),
                          ColocarTexto(texto: desc),
                        ],
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    children: [],
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
