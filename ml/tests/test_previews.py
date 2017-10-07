from crowdcount.models import paths
import crowdcount.ml as ml


def test_label_preview(previewer):
    previewer.show(paths.get('shakecam').key_for(None))


def test_shakecam_preview(predictor, previewer, shakecam_key):
    prediction = predictor.predict_line(ml.load_img(shakecam_key))
    truth = predictor.predict_line_from_truth(shakecam_key)
    previewer.show(shakecam_key, prediction, truth)


def test_mall_preview(predictor, previewer, mall_key):
    prediction = predictor.predict_line(ml.load_img(mall_key))
    previewer.show(mall_key, prediction)
