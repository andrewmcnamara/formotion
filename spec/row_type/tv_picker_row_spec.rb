describe "TableView Picker Row" do
  tests_row title: "TableView Picker", key: :tv_picker, type: :tv_picker, value: "Motion", tv_controller: 'some_controller'

  it "should initialize with correct settings" do
    @row.object.class.should == Formotion::RowType::TvPickerRow
  end

  it "should build cell with a label and an accessory" do
    cell = @row.make_cell
    cell.accessoryType.should == UITableViewCellAccessoryDisclosureIndicator
    cell.textLabel.text.should == 'Motion'
  end

  it "should set the tableview controller to object provided in the hash" do
    cell = @row.make_cell
    @row.tv_controller.should == "some_controller"
  end

end