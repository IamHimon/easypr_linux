#include "chars_identify.h"
#include "config.h"
#include "core_func.h"

namespace easypr {

CharsIdentify* CharsIdentify::instance_ = nullptr;

CharsIdentify* CharsIdentify::instance() {
  if (!instance_) {
    instance_ = new CharsIdentify;
  }
  return instance_;
}

CharsIdentify::CharsIdentify() {
  ann_ = ml::ANN_MLP::load(kDefaultAnnPath);
  kv_ = std::shared_ptr<Kv>(new Kv);
  kv_->load("etc/province_mapping");
}

std::pair<std::string, std::string> CharsIdentify::identify(cv::Mat input) {
  cv::Mat feature = features(input, kPredictSize);
  auto index = static_cast<int>(ann_->predict(feature));
  if (index < 34) {
    return std::make_pair(kChars[index], kChars[index]);
  } else {
    const char* key = kChars[index];
    std::string s = key;
    std::string province = kv_->get(s);
    return std::make_pair(s, province);
  }
}
}
