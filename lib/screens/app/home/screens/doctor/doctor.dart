import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:skin_detective/gen/assets.gen.dart';
import 'package:skin_detective/models/doctor/doctor.dart';
import 'package:skin_detective/screens/app/home/screens/doctor/doctor.logic.dart';
import 'package:skin_detective/theme/color.dart';
import 'package:skin_detective/theme/fonts.dart';
import 'package:skin_detective/utils/multi_languages/locale_keys.dart';
import 'package:skin_detective/widgets/image_custom/image_custom.dart';

import '../doctor_detail/doctor_detail.dart';

class DoctorPage extends StatefulWidget {
  const DoctorPage({Key? key}) : super(key: key);

  @override
  _DoctorPageState createState() => _DoctorPageState();
}

class _DoctorPageState extends State<DoctorPage>
    with AutomaticKeepAliveClientMixin {
  late DoctorLogic doctorLogic;

  @override
  void initState() {
    super.initState();
    doctorLogic = Provider.of<DoctorLogic>(context, listen: false);
  }

  @override
  void dispose() {
    doctorLogic.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return SafeArea(
      child: Selector<DoctorLogic, List<Doctor>>(
        selector: (_, __) => __.doctors,
        builder: (context, doctors, snapshot) {
          return RefreshIndicator(
            onRefresh: () async => doctorLogic.onRefresh(),
            backgroundColor: AppColors.white,
            color: AppColors.textBlack,
            child: Container(
              margin: const EdgeInsets.all(24.0),
              decoration: const BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.all(Radius.circular(8.0))),
              child: ListView.separated(
                separatorBuilder: (context, index) {
                  return const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 18),
                    child: Divider(height: 1, color: AppColors.lightGray),
                  );
                },
                itemCount: doctors.length,
                itemBuilder: ((context, index) =>
                    DoctorItem(doctor: doctors[index])),
              ),
            ),
          );
        },
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}

class DoctorItem extends StatelessWidget {
  final Doctor doctor;

  const DoctorItem({Key? key, required this.doctor}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        //Push to Screen detail
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => DoctorDetailPage(
              doctor: doctor,
            ),
          ),
        );
      },
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(18.0),
            child: ClipRRect(
              borderRadius: const BorderRadius.all(Radius.circular(30)),
              child: ImageCustom(
                urlImage: doctor.image,
                fit: BoxFit.cover,
                width: 56,
                height: 56,
                placeHolderType: PlaceHolderType.imageAsset,
              ),
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  doctor.detail!.name.toString(),
                  style: Theme.of(context).textTheme.subtitle1!.copyWith(
                        fontWeight: FontWeight.w700,
                        fontFamily: Assets.googleFonts.montserratBold,
                        color: AppColors.textBlueBlack,
                      ),
                ),
                const SizedBox(height: 4),
                Text(
                  doctor.detail!.workPlace.toString(),
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.subtitle1!.copyWith(
                        fontSize: AppFonts.font_11,
                        color: AppColors.textBlueBlack,
                        fontWeight: FontWeight.w400,
                      ),
                ),
                const SizedBox(height: 4),
                Text(
                  LocaleKeys.spaConsultantFee,
                  style: Theme.of(context).textTheme.subtitle1!.copyWith(
                        fontFamily: Assets.googleFonts.montserratSemiBold,
                        fontSize: AppFonts.font10,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textBlue,
                      ),
                ).tr(args: [doctor.detail!.serviceFee]),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
