import 'package:get/get.dart';
import '../../../common/base/widgets/base_widgets.dart';

import '../api/response/base_response.dart';
import '../app_error.dart';
import 'observer_func.dart';

class BaseController extends GetxController with BaseCustomWidgets {
  Future subscribe({
    required Future<BaseResponse> future,
    ObserverFunc? observer,
    bool isShowLoading = false,
    int? delay,
  }) async {
    if (isShowLoading) {
      showLoadingDialog();
    }
    observer?.onSubscribe();
    if (delay != null && delay != 0) {
      await Future.delayed(Duration(milliseconds: delay));
    }
    try {
      final value = await future;
      observer?.onSuccess(value);
    } on Exception catch (e) {
      observer?.onError(AppError(e));
    } finally {
      hideLoading(isShowLoading);
      observer?.onCompleted();
    }
  }

  void hideLoading(isLoading) {
    if (isLoading) {
      hideLoadingDialog();
    }
  }
}
