import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_place_picker/google_maps_place_picker.dart';
import 'package:provider/provider.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:avatar_glow/avatar_glow.dart';
import 'dbutil.dart';
import 'map.dart';
import 'model/keys.dart';

final globalScaffoldKey = GlobalKey<ScaffoldState>();

class AddPage extends StatefulWidget{
  const AddPage({Key? key, required this.date}) : super(key: key);

  final Timestamp date;

  @override
  _AddPage createState() => _AddPage();
}

class _AddPage extends State<AddPage>{

  //입금/지출, 금액, 카테고리, 메
  List<bool> isSelected = List.generate(2, (index) => false);
  final _categoryController = TextEditingController();
  final _priceController = TextEditingController();
  final _memoController = TextEditingController();

  PickResult selectedPlace = PickResult();

  GeoPoint? geoPoint;
  String? address;

  //현금/카드 선택
  // final paymentList = ['cash','nonghyup', 'kookmin']; //db에서 리스트 갖고오기..
  // var payment='cash';

  final stt.SpeechToText _speech = stt.SpeechToText();

  bool _isListening = false;
  String _text = '자동 입력';
  double _confidence = 1.0; //음성인식 정확도


  //Language selectedLang =
  @override
  void dispose(){
    _categoryController.dispose();
    _priceController.dispose();
    _memoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: globalScaffoldKey,
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          centerTitle: true,
          leading: TextButton(
            child: const Text('Cancel',
              style: TextStyle(color: Colors.white, fontSize: 12),),
            onPressed: () {
              Navigator.pop(context,'');
            },
          ),
          title: const Text('Add'),
          actions: <Widget>[
            Consumer<ApplicationState>(
              builder: (context, appState, _) => TextButton(
                child: const Text('Save',
                  style: TextStyle(color: Colors.white, fontSize: 17),
                ),
                onPressed: (){
                  appState.addItem(
                    _categoryController.text,
                    (isSelected[0]==true)? true : false,
                    int.parse(_priceController.text),
                    _memoController.text,
                    widget.date,
                    address!,
                    geoPoint!,
                  );
                  Navigator.pop(context);
                }
              ),
            ),
          ],
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              margin: const EdgeInsets.all(25),
              child: Column(
                children: [
                  ToggleButtons(children: const <Widget>[
                    Padding(
                      padding: EdgeInsets.all(8),
                      child: Text('지출'),
                    ),
                    Padding(
                        padding: EdgeInsets.all(8),
                        child: Text('수입'),
                    ),
                  ],
                  onPressed: (int index){
                    setState(() {
                      for(int i=0; i<isSelected.length; i++){
                        isSelected[i] = i ==index;
                      }
                    });
                  },
                    isSelected: isSelected,
                  ),
                  TextField(
                    decoration: const InputDecoration(labelText: '카테고리'),
                    controller: _categoryController,
                  ),
                  TextField(
                    decoration: const InputDecoration(labelText: '금액'),
                    controller: _priceController,
                  ),
                  Row(
                    children: [
                      Container(
                        child: TextField(
                          decoration: const InputDecoration(labelText: '메모'),
                          controller: _memoController,
                        ),
                          width: 300,
                      ),
                      AvatarGlow(
                        animate: _isListening,
                        glowColor: Theme.of(context).primaryColor,
                        endRadius: 20,
                        duration: const Duration(milliseconds: 2000),
                        repeatPauseDuration: const Duration(milliseconds: 100),
                        repeat: true,
                        child: IconButton(
                          onPressed: _listen,
                          icon: Icon(_isListening ? Icons.mic : Icons.mic_none),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12.0),
                  ElevatedButton(
                    child: const Text("위치 정하기"),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) {
                            return PlacePicker(
                              apiKey: APIKeys.apiKey,
                              initialPosition: MapPage.kInitialPosition,
                              useCurrentLocation: true,
                              selectInitialPosition: true,

                              //usePlaceDetailSearch: true,
                              onPlacePicked: (result) {
                                selectedPlace = result;

                                geoPoint = GeoPoint(selectedPlace.geometry!.location.lat, selectedPlace.geometry!.location.lng);
                                address = selectedPlace.formattedAddress;

                                Navigator.of(context).pop();
                                setState(() {});
                              },
                            );
                          },
                        ),
                      );
                    },
                  ),
                  selectedPlace == null ? Container() : Text(address ?? ""),
                  
                  // DropdownButton(
                  //     value: payment,
                  //     items: paymentList.map((value){
                  //       return DropdownMenuItem(
                  //           child: Text(value),
                  //         value: value,);
                  //     },).toList(),
                  //   onChanged: (value){
                  //     setState((){
                  //       payment = value.toString();
                  //   });
                  //   }),
                ],
              ),
            )
          ],
        ),
    );
  }
  void _listen() async {
    if (!_isListening) {
      bool available = await _speech.initialize(
        onStatus: (val) => print('onStatus: $val'),
        onError: (val) => print('onError: $val'),
      );
      if (available) {
        setState(() => _isListening = true);
        _speech.listen(
          localeId: "ko-KR",
          onResult: (result) =>
              setState(() {
                _text = result.recognizedWords;
                if (result.hasConfidenceRating && result.confidence > 0) {
                  _confidence = result.confidence;
                }
              }),
        );
      }
    } else {
      setState(() {
        _isListening = false;
        _memoController.text = _text;
        _text = '';
      });
      _speech.stop();
    }
  }
}
