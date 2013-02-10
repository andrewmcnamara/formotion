module Formotion
  module RowType
    class TvPickerRow < Base

      LABEL_TAG=1001

      def build_cell(cell)
        self.row.tv_controller.extend Formotion::RowType::TvPickerRow::Delegate
                                      #.class.send(:include,Formotion::RowType::TvPickerRow::Delegate)

        cell.accessoryType = cell.editingAccessoryType = UITableViewCellAccessoryDisclosureIndicator

        cell.contentView.addSubview(self.display_key_label)
        self.display_key_label.text = row.value if row.value
        cell.swizzle(:layoutSubviews) do
          def layoutSubviews
            old_layoutSubviews

            formotion_label = self.viewWithTag(LABEL_TAG)
            formotion_label.sizeToFit

            field_frame = formotion_label.frame
            field_frame.origin.x = self.contentView.frame.size.width - field_frame.size.width - 10
            field_frame.origin.y = ((self.contentView.frame.size.height - field_frame.size.height) / 2.0).round
            formotion_label.frame = field_frame
          end
        end

        display_key_label.highlightedTextColor = cell.textLabel.highlightedTextColor
      end

      def on_select(tableView, tableViewDelegate)
        presenting_controller ||= UIApplication.sharedApplication.keyWindow.rootViewController
        tv_picker = self.row.tv_controller
        tv_picker.delegate = self
        presenting_controller.presentViewController(tv_picker, animated: true, completion: lambda {})
      end


      def selectRowFromTvPicker object
        UIApplication.sharedApplication.keyWindow.rootViewController.dismissViewControllerAnimated(true, completion: lambda {})
        row.value=object
        self.display_key_label.text = row.value
      end

      def display_key_label
        @display_key_label ||= begin
          label = UILabel.alloc.initWithFrame(CGRectZero)
          label.textColor = "#385387".to_color
          label.tag = LABEL_TAG
          label.backgroundColor = UIColor.clearColor
          label
        end
      end

      module Delegate
        attr_accessor :delegate

        def self.extended(base)
        end

        def selectRow object
          delegate.selectRowFromTvPicker object
        end

      end

    end

  end
end
