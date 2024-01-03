import 'package:flutter_polyline_points/flutter_polyline_points.dart';

import '../models/direction.dart';
import '../models/place.dart';

List<Place> listPlacesSearchByCategories = [
  Place(
    name: 'Ben Thanh Market',
    longitude: 106.6980,
    latitude: 10.7725,
  ),
  Place(
    name: 'Sala',
    longitude: 106.7220,
    latitude: 10.7721,
  ),
  Place(
    name: 'Landmark 81',
    longitude: 106.7218,
    latitude: 10.7950,
  ),
  Place(
    name: 'Sai Gon Zoo',
    longitude: 106.7053,
    latitude: 10.7875,
  ),
  Place(
    name: 'Independence Palace',
    longitude: 106.6953,
    latitude: 10.7770,
  ),
];

List<Directions> listDirection = [
  Directions(
    polylinePoints: PolylinePoints().decodePolyline(
        'o}v`AqjfjSwBdAnCnFxAfCvAa@LEJ}BAy@E[Ci@{@wCKq@?YF]To@NSn@{AjAw@h@]bCsA|EeCjFgCr@g@PQl@Pf@TZDz@d@`@P\\VLJp@z@\\j@JRZQTQ]c@k@y@kAiAs@c@uCwAcBaAq@o@}AmBo@cAYo@Si@s@qCe@gEcAyJ_AgJg@eFmBePSaCS_Cu@qKSsBEY\\Gy@eEw@}D_@iByA{F~BaA~Ao@[i@}@mBg@kAMX'),
  ),
  Directions(
    polylinePoints: PolylinePoints().decodePolyline(
        '_zv`AodkjSNLF?J?_@}@w@kBc@kAq@Vq@Vi@Tu@AUJc@Pk@Zk@Ty@P{ALkA@aAEmDUcBIaBAmBFqANkATy@R{@ZsF`CuB`AwEvBg@V}CnA{DjBs@Vs@XkCnAyFdCgDlAS?KBi@T_HpCq@?SCOGOOMMGCQe@Wi@]a@YWe@[q@]q@Sq@Km@CmCEwCAeCAkF@oAIm@Kg@Oo@_@c@a@c@m@l@i@jAcAkDuFCQ@KnAeC~AcD`@D~@H@FFHD@'),
  ),
  Directions(
    polylinePoints: PolylinePoints().decodePolyline(
        '{j{`AuekjSr@FHCBO?Ej@Cv@EfAQVINCHG?GEEKAa@HwBV{A@uAGcBYuAc@gAo@wEkEe@_@[S]MYCW?wARWJIJMPYh@GXAh@@n@@f@LfEHbAJl@\\~@n@hBFbAARU`As@bBRLeBjDgA|BwBfFcAxC_@hAk@pBqAjHBNKbCIbD?rAF`BHbAl@nFLnAVvAPb@d@zAXn@x@`B|ApCdB~Bj@p@vKdKtBnBnFdFjChCxClClCbCd@d@p@v@AL@LJ`@NRVDLCHGJYAYIYvAeB~@cA|A_B`DqDhBsBrC{ChF_G`BgB'),
  ),
  Directions(
    polylinePoints: PolylinePoints().decodePolyline(
        'k{y`AeygjStEhExDlDjA~@hDxCnI~HrCfChDdDPLFDBL@BHJb@d@@DFHJBD?b@b@PDHF\\^xBzBj@d@p@p@`BrAh@h@NMf@Sr@Bd@RLNDRBVEXWh@KJ'),
  ),
];
