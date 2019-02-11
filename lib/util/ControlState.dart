import 'package:tiny_release/data/tiny_dbo.dart';

class ControlScreenState {
  /// the selected item databasedId
  int selectedItemId = -1;

  /// the selected control item
  int selectedControlItem = 0;

  /// the current selected data item
  TinyDBO curDBO;

  /// used to manage split view on large displays
  Function setShowNavBackButton;
  Function setShowEditButton;
  Function setShowAddButton;
  Function setShowSaveButton;
  Function setShowContactImportButton;

  ControlScreenState( this.setShowNavBackButton, this.setShowAddButton, this.setShowEditButton, this.setShowSaveButton, this.setShowContactImportButton );

  /// sets the toolbar active buttons when in splitscreen mode
  void setToolbarButtonsOnList() {
    setShowEditButton( false );
    setShowAddButton( true );
    setShowNavBackButton( false );
    setShowSaveButton( false );
    setShowContactImportButton( false );
  }

  void setToolbarButtonsOnPreview() {
    setShowEditButton( true );
    setShowAddButton( false );
    setShowNavBackButton( true );
    setShowSaveButton( false );
    setShowContactImportButton( false );
  }

  void setToolbarButtonsOnEdit() {
    setShowEditButton( false );
    setShowAddButton( false );
    setShowNavBackButton( true );
    setShowSaveButton( true );
    setShowContactImportButton( true );
  }

  void setToolbarButtonsOnImport() {
    setShowEditButton( false );
    setShowAddButton( false );
    setShowNavBackButton( true );
    setShowSaveButton( false );
    setShowContactImportButton( false );
  }
}