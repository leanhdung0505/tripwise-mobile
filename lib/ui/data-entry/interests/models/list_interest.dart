import 'package:get/get.dart';
import 'package:trip_wise_app/resource/asset/app_images.dart';

import 'interest_model.dart';

class ListInterest {
  Rx<List<InterestModel>> listInterest = Rx(
    [
      InterestModel(
        id: '1',
        name: 'beach'.tr,
        image: AppImages.icBeach,
        isSelected: false,
        value: 'Beach',
      ),
      InterestModel(
        id: '2',
        name: 'museum'.tr,
        image: AppImages.icMuseum,
        isSelected: false,
        value: 'Museum',
      ),
      InterestModel(
        id: '3',
        name: 'food'.tr,
        image: AppImages.icFood,
        isSelected: false,
        value: 'Food',
      ),
      InterestModel(
        id: '4',
        name: 'shopping'.tr,
        image: AppImages.icShopping,
        isSelected: false,
        value: 'Shopping',
      ),
      InterestModel(
        id: '5',
        name: 'adventure'.tr,
        image: AppImages.icAdventure,
        isSelected: false,
        value: 'Adventure',
      ),
      InterestModel(
        id: '6',
        name: 'hiking'.tr,
        image: AppImages.icHiking,
        isSelected: false,
        value: 'Hiking',
      ),
      InterestModel(
        id: '7',
        name: 'relaxation'.tr,
        image: AppImages.icRelaxation,
        isSelected: false,
        value: 'Relaxation',
      ),
      InterestModel(
        id: '8',
        name: 'spa'.tr,
        image: AppImages.icSpa,
        isSelected: false,
        value: 'Spa',
      ),
      InterestModel(
        id: '9',
        name: 'cultural'.tr,
        image: AppImages.icCultural,
        isSelected: false,
        value: 'Cultural',
      ),
      InterestModel(
        id: '10',
        name: 'historical'.tr,
        image: AppImages.icHistorical,
        isSelected: false,
        value: 'Historical',
      ),
      InterestModel(
        id: '11',
        name: 'nature'.tr,
        image: AppImages.icNature,
        isSelected: false,
        value: 'Nature',
      ),
      InterestModel(
        id: '12',
        name: 'sightseeing'.tr,
        image: AppImages.icSightseeing,
        isSelected: false,
        value: 'Sightseeing',
      ),
    ],
  );
}