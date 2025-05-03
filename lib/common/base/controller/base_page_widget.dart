import 'package:get/get.dart';
import '../../../common/base/controller/base_controller.dart';
import '../../../common/base/widgets/base_widgets.dart';

abstract class BasePage<Controller extends BaseController> extends GetView<Controller> with BaseCustomWidgets {
  const BasePage({super.key});
}
