class ControlScreenState {
  int selectedControlItem = -1;
  bool navBack = false;
  Function setShowNavBackButton;
  Function setShowEditButton;
  Function setShowAddButton;

  ControlScreenState( this.setShowNavBackButton, this.setShowAddButton, this.setShowEditButton );

  void setToolbarButtonsOnList() {
    setShowEditButton( false );
    setShowAddButton( true );
    setShowNavBackButton( false );
  }

  void setToolbarButtonsOnPreview() {
    setShowEditButton( true );
    setShowAddButton( false );
    setShowNavBackButton( true );
  }

  void setToolbarButtonsOnEdit() {
    setShowEditButton( false );
    setShowAddButton( false );
    setShowNavBackButton( true );
  }
}