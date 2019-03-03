import 'dart:io' as Io;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tiny_release/data/repo/tiny_address_repo.dart';
import 'package:tiny_release/data/repo/tiny_settings_repo.dart';
import 'package:tiny_release/data/tiny_contract.dart';
import 'package:tiny_release/data/tiny_setting.dart';

class ContractPdfGenerator {
  final TinySettingRepo _tinySettingRepo = TinySettingRepo();
  final TinyAddressRepo _tinyAddressRepo = TinyAddressRepo();
  final TinyContract _tinyContract;

  String photographerLabel, modelLabel;

  ContractPdfGenerator(this._tinyContract) {
    photographerLabel = "Fotograf";
    modelLabel = "Model";
//    _tinySettingRepo.getForKey(TinySettingKey.PHOTOGRAPHER_LABEL).then((ts) => this.photographerLabel = ts.value);
//    _tinySettingRepo.getForKey(TinySettingKey.MODEL_LABEL).then((ts) => this.modelLabel = ts.value);
  }

  void generatePdf() {

  }

  Widget buildContractHeader() =>
      ListTile(
          leading: // photographer section
          Column(children: <Widget>[
            Text(photographerLabel),
            Text(_tinyContract.photographer.displayName),
            Text(_tinyContract.selectedPhotographerAddress.street),
            Text(_tinyContract.selectedPhotographerAddress.postcode + " " +
                _tinyContract.selectedPhotographerAddress.city),
          ],),
          title: _tinyContract.model.avatar != null ? Image.file(
              Io.File(_tinyContract.model.avatar)) : Container(),

          trailing: Column(children: <Widget>[
            Text(modelLabel),
            Text(_tinyContract.model.displayName),
            Text(_tinyContract.selectedModelAddress.street),
            Text(_tinyContract.selectedModelAddress.postcode + " " +
                _tinyContract.selectedModelAddress.city),
          ],)
      );
}