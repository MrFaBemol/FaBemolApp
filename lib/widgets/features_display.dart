import 'package:FaBemol/data/data.dart';
import 'package:FaBemol/widgets/container_flat_design.dart';
import 'package:FaBemol/widgets/language_picker.dart';
import 'package:FaBemol/functions/localization.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';

class FeaturesDisplay extends StatelessWidget {
  final Function switchToForm;

  FeaturesDisplay(this.switchToForm);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // ******* LE LANGUAGE PICKER
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'language'.tr() + ' : ',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            SizedBox(
              width: 10,
            ),
            LanguagePicker(),
          ],
        ),
        // Les Features

        Expanded(child: FeaturesSwiper()),

        SizedBox(height: 5),

        // Le bouton pour switch

        Container(
          margin: EdgeInsets.only(top: 5),
          height: 40,
          width: double.infinity,
          padding: EdgeInsets.symmetric(horizontal: 50),
          child: ElevatedButton(
            onPressed: switchToForm,
            child: Text(
              'button_lets_go'.tr().toUpperCase(),
            ),
          ),
        ),

        SizedBox(height: 10),
      ],
    );
  }
}

//************************************************************************** FEATURE
class FeaturesSwiper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Swiper(
      loop: false,
      itemCount: DATA.FEATURES.length,
      itemBuilder: (context, i) {
        return Stack(
          children: [
            Padding(
              // Le padding pour faire l'effet 3D (la card commence assez bas)
              padding: const EdgeInsets.only(top: 160, bottom: 10, left: 10, right: 10),

              // LA CARD ****************************************
              child: ContainerFlatDesign(
                borderRadius: BorderRadius.circular(20),
                padding: EdgeInsets.all(10),
                child: Column(
                  children: [
                    // La place libre pour l'image
                    SizedBox(
                      height: 35,
                    ),

                    // LE TITRE ****************************************
                    SizedBox(
                      width: double.infinity,
                      child: AutoSizeText(
                        DATA.FEATURES[i]['title'].toString().tr(),
                        style: Theme.of(context).textTheme.headline5,
                        textAlign: TextAlign.center,
                        maxLines: 2,
                      ),
                    ),

                    // LA DESCRIPTION ****************************************
                    Expanded(
                      child: SingleChildScrollView(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: AutoSizeText(
                            DATA.FEATURES[i]['description'].toString().tr(),
                            textAlign: TextAlign.justify,
                            style: TextStyle(fontSize: 18),
                          ),
                        ),
                      ),
                    ),

                    // POUR GARDER LA PAGINATION INTACTE*************
                    SizedBox(
                      height: 22,
                    )
                  ],
                ),
              ),
            ),

            // L'IMAGE ****************************************
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  DATA.FEATURES[i]['image'],
                  fit: BoxFit.fill,
                  scale: (DATA.FEATURES[i]['scale'] != null) ? DATA.FEATURES[i]['scale'] : 1.15,
                )
              ],
            ),
          ],
        );
      },

      // Les petites boules de la pagination
      pagination: new SwiperPagination(
        alignment: Alignment.bottomCenter,
        builder: new DotSwiperPaginationBuilder(color: Colors.grey[300], activeColor: Theme.of(context).accentColor),
      ),
      viewportFraction: 0.85,
      scale: 0.95,
    );
  }
}
