class ControlScreenState {
  /// the selected item databasedId
  int selectedItemId = -1;

  /// the selected control item
  int selectedControlItem = -1;

  bool navBack = false;
  Function setShowNavBackButton;
  Function setShowEditButton;
  Function setShowAddButton;
  Function setShowSaveButton;

  ControlScreenState( this.setShowNavBackButton, this.setShowAddButton, this.setShowEditButton, this.setShowSaveButton );

  void setToolbarButtonsOnList() {
    setShowEditButton( false );
    setShowAddButton( true );
    setShowNavBackButton( false );
    setShowSaveButton( false );
  }

  void setToolbarButtonsOnPreview() {
    setShowEditButton( true );
    setShowAddButton( false );
    setShowNavBackButton( true );
    setShowSaveButton( false );
  }

  void setToolbarButtonsOnEdit() {
    setShowEditButton( false );
    setShowAddButton( false );
    setShowNavBackButton( true );
    setShowSaveButton( true );
  }
}