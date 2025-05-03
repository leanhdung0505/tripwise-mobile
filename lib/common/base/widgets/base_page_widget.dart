import 'package:get/get.dart';
import 'package:trip_wise_app/common/base/controller/base_controller.dart';
import 'package:trip_wise_app/common/base/widgets/base_widgets.dart';

abstract class BasePage<Controller extends BaseController>
    extends GetView<Controller> with BaseCustomWidgets {
  const BasePage({super.key});
}
