// ignore_for_file: non_constant_identifier_names

@JS('libpag')
library;

import 'dart:async';
import 'dart:js_interop';
import 'package:web/web.dart' as web;

Future<PAG> libPAG = () async {
  await loadScript('4.5.85');
  final value = await initPAG().toDart;
  return value;
}();

Future<void> loadScript(String version) async {
  final completer = Completer<void>();
  try {
    final head = ArgumentError.checkNotNull(web.document.head, 'head');
    final script =
        web.document.createElement('script') as web.HTMLScriptElement;
    script.type = 'module';
    script.src =
        'https://cdn.jsdelivr.net/npm/libpag@$version/lib/libpag.min.js';
    script.onload = ((web.Event _) => completer.complete()).toJS;
    script.onerror = ((web.ErrorEvent e) => completer.completeError(e)).toJS;
    head.append(script);
  } catch (e) {
    completer.completeError(e);
  }
  await completer.future;
}

// ========== classes ==========

/// 对应 `libpag.PAGInit(moduleOption?)`。
@JS('PAGInit')
external JSPromise<PAG> initPAG([ModuleOption? moduleOption]);

/// 对应全局 `fetch`，用于 Web 端按 URL 加载 .pag 文件。
@JS('fetch')
external JSPromise<web.Response> fetch(String url);

/// WASM 模块实例，对应 `types.PAG`。
/// libpag 4.x 中 `PAGFile`/`PAGView` 等构造类均挂在 PAGInit() 返回的
/// PAG 实例上（如 `PAG.PAGFile.load(...)`），而非全局 `libpag` 命名空间，
/// 因此通过下方 getter 从实例取构造类。
extension type PAG._(JSObject _) implements JSObject {
  @JS('SDKVersion')
  external String sdkVersion();

  external PAGFileCtor get PAGFile;
  external PAGCompositionCtor get PAGComposition;
  external PAGImageCtor get PAGImage;
  external PAGImageLayerCtor get PAGImageLayer;
  external PAGTextLayerCtor get PAGTextLayer;
  external PAGSolidLayerCtor get PAGSolidLayer;
  external PAGSurfaceCtor get PAGSurface;
  external PAGPlayerCtor get PAGPlayer;
  external PAGViewCtor get PAGView;
  external PAGFontCtor get PAGFont;
  external MatrixCtor get Matrix;
}

// ========== 构造类（PAG 实例上的静态类对象） ==========

/// 对应 `PAG.PAGFile` 构造类。
extension type PAGFileCtor._(JSObject _) implements JSObject {
  /// 从 File/Blob/ArrayBuffer 异步加载，对应 `PAGFile.load(data)`。
  external JSPromise<PAGFile> load(JSAny data);
  external PAGFile loadFromBuffer(JSArrayBuffer buffer);
  external int maxSupportedTagLevel();
}

/// 对应 `PAG.PAGComposition` 构造类。
extension type PAGCompositionCtor._(JSObject _) implements JSObject {
  external PAGComposition make(num width, num height);
}

/// 对应 `PAG.PAGImage` 构造类。
extension type PAGImageCtor._(JSObject _) implements JSObject {
  external JSPromise<PAGImage> fromFile(web.File data);
  external PAGImage fromSource(JSObject source);
  external PAGImage fromPixels(
    JSUint8Array pixels,
    num width,
    num height,
    ColorType colorType,
    AlphaType alphaType,
  );
  external PAGImage fromTexture(
    num textureID,
    num width,
    num height,
    bool flipY,
  );
}

/// 对应 `PAG.PAGImageLayer` 构造类。
extension type PAGImageLayerCtor._(JSObject _) implements JSObject {
  external PAGImageLayer make(num width, num height, int duration);
}

/// 对应 `PAG.PAGTextLayer` 构造类。
extension type PAGTextLayerCtor._(JSObject _) implements JSObject {
  /// 字符串参数重载，对应 `PAGTextLayer.make(duration, text, fontSize, fontFamily, fontStyle)`。
  external PAGTextLayer make(
    num duration,
    String text,
    num fontSize,
    String fontFamily,
    String fontStyle,
  );

  /// TextDocument 参数重载（JS 侧同名 `make`），Dart 侧改名避免冲突。
  @JS('make')
  external PAGTextLayer makeFromDocument(
    num duration,
    TextDocument textDocumentHandle,
  );
}

/// 对应 `PAG.PAGSolidLayer` 构造类。
extension type PAGSolidLayerCtor._(JSObject _) implements JSObject {
  external PAGSolidLayer make(
    int duration,
    num width,
    num height,
    Color solidColor,
    num opacity,
  );
}

/// 对应 `PAG.PAGSurface` 构造类。
extension type PAGSurfaceCtor._(JSObject _) implements JSObject {
  external PAGSurface fromCanvas(String canvasID);
  external PAGSurface fromTexture(
    num textureID,
    num width,
    num height,
    bool flipY,
  );
  external PAGSurface fromRenderTarget(
    num frameBufferID,
    num width,
    num height,
    bool flipY,
  );
}

/// 对应 `PAG.PAGPlayer` 构造类。
extension type PAGPlayerCtor._(JSObject _) implements JSObject {
  external PAGPlayer create();
}

/// 对应 `PAG.PAGView` 构造类。
extension type PAGViewCtor._(JSObject _) implements JSObject {
  /// 对应 `PAGView.init(file, canvas, initOptions?)`。
  /// 返回类型为 `JSPromise<PAGView>`：init 是唯一完成渲染初始化的入口，
  /// 它会创建 renderCanvas/pagGlContext/pagSurface 并 setSurface/setComposition。
  external JSPromise<PAGView> init(
    PAGComposition file,
    JSAny canvas, [
    JSObject? initOptions,
  ]);
}

/// 对应 `PAG.PAGFont` 构造类。
extension type PAGFontCtor._(JSObject _) implements JSObject {
  external PAGFont create(String fontFamily, String fontStyle);
  external JSPromise<JSAny?> registerFont(String family, web.File data);
  external void registerFallbackFontNames([JSArray<JSString>? fontNames]);
}

/// 对应 `PAG.Matrix` 构造类。
extension type MatrixCtor._(JSObject _) implements JSObject {
  external Matrix makeAll(
    double scaleX,
    double skewX,
    double transX,
    double skewY,
    double scaleY,
    double transY, [
    double pers0,
    double pers1,
    double pers2,
  ]);
  external Matrix makeScale(double scaleX, [double scaleY]);
  external Matrix makeTrans(double dx, double dy);
}

/// 图层基类，对应 `pag-layer.PAGLayer`。
extension type PAGLayer._(JSObject _) implements JSObject {
  external int uniqueID();
  external LayerType layerType();
  external String layerName();
  external Matrix matrix();
  external void setMatrix(Matrix matrix);
  external void resetMatrix();
  external Matrix getTotalMatrix();
  external num alpha();
  external void setAlpha(num opacity);
  external bool visible();
  external void setVisible(bool visible);
  external int editableIndex();
  external PAGComposition parent();
  external Vector markers();
  external int localTimeToGlobal(int localTime);
  external int globalToLocalTime(int globalTime);
  external int duration();
  external int frameRate();
  external int startTime();
  external void setStartTime(int time);
  external int currentTime();
  external void setCurrentTime(int time);
  external num getProgress();
  external void setProgress(num percent);
  external void preFrame();
  external void nextFrame();
  external Rect getBounds();
  external PAGLayer trackMatteLayer();
  external bool excludedFromTimeline();
  external void setExcludedFromTimeline(bool value);
  external bool isPAGFile();
  external PAGLayer asTypeLayer();
  external bool isDelete();
  external void destroy();
}

/// 画布合成容器，对应 `pag-composition.PAGComposition`。
extension type PAGComposition._(JSObject _) implements PAGLayer {
  external num width();
  external num height();
  external void setContentSize(num width, num height);
  external int numChildren();
  external PAGLayer getLayerAt(int index);
  external int getLayerIndex(PAGLayer pagLayer);
  external int setLayerIndex(PAGLayer pagLayer, int index);
  external bool addLayer(PAGLayer pagLayer);
  external bool addLayerAt(PAGLayer pagLayer, int index);
  external bool contains(PAGLayer pagLayer);
  external PAGLayer removeLayer(PAGLayer pagLayer);
  external PAGLayer removeLayerAt(int index);
  external void removeAllLayers();
  external void swapLayer(PAGLayer pagLayer1, PAGLayer pagLayer2);
  external void swapLayerAt(int index1, int index2);
  external JSUint8Array? audioBytes();
  external Vector audioMarkers();
  external int audioStartTime();
  external VecArray getLayersByName(String layerName);
  external VecArray getLayersUnderPoint(num localX, num localY);
}

/// PAG 文件，对应 `pag-file.PAGFile`。
extension type PAGFile._(JSObject _) implements PAGComposition {
  external int tagLevel();
  external int numTexts();
  external int numImages();
  external int numVideos();
  external TextDocument getTextData(int editableTextIndex);
  external void replaceText(int editableTextIndex, TextDocument textData);
  external void replaceImage(int editableImageIndex, PAGImage? pagImage);
  external VecArray getLayersByEditableIndex(
    int editableIndex,
    LayerType layerType,
  );
  external JSArray<JSNumber> getEditableIndices(LayerType layerType);
  external PAGTimeStretchMode timeStretchMode();
  external void setTimeStretchMode(PAGTimeStretchMode value);
  external void setDuration(int duration);
  external PAGFile copyOriginal();
}

/// 图片图层，对应 `pag-image-layer.PAGImageLayer`。
extension type PAGImageLayer._(JSObject _) implements PAGLayer {
  external int contentDuration();
  external JSArray<JSObject> getVideoRanges();
  external void replaceImage(PAGImage? pagImage);
  external void setImage(PAGImage pagImage);
  external int layerTimeToContent(int layerTime);
  external int contentTimeToLayer(int contentTime);
  external JSUint8Array? imageBytes();
}

/// 文本图层，对应 `pag-text-layer.PAGTextLayer`。
extension type PAGTextLayer._(JSObject _) implements PAGLayer {
  external Color fillColor();
  external void setFillColor(Color value);
  external PAGFont font();
  external void setFont(PAGFont pagFont);
  external num fontSize();
  external void setFontSize(num size);
  external Color strokeColor();
  external void setStrokeColor(Color value);
  external String text();
  external void setText(String text);
  external void reset();
}

/// 纯色图层，对应 `pag-solid-layer.PAGSolidLayer`。
extension type PAGSolidLayer._(JSObject _) implements PAGLayer {
  external Color solidColor();
  external void setSolidColor(Color color);
}

/// 图片对象，对应 `pag-image.PAGImage`。
extension type PAGImage._(JSObject _) implements JSObject {
  external num width();
  external num height();
  external PAGScaleMode scaleMode();
  external void setScaleMode(PAGScaleMode scaleMode);
  external Matrix matrix();
  external void setMatrix(Matrix matrix);
  external void destroy();
}

/// 渲染表面，对应 `pag-surface.PAGSurface`。
extension type PAGSurface._(JSObject _) implements JSObject {
  external num width();
  external num height();
  external void updateSize();
  external bool clearAll();
  external void freeCache();
  external JSUint8Array? readPixels(ColorType colorType, AlphaType alphaType);
  external void destroy();
}

/// 字体对象，对应 `pag-font.PAGFont`。
extension type PAGFont._(JSObject _) implements JSObject {
  external String get fontFamily;
  external String get fontStyle;
  external void destroy();
}

/// 播放器（无 UI 控制），对应 `pag-player.PAGPlayer`。
extension type PAGPlayer._(JSObject _) implements JSObject {
  external void setProgress(num progress);
  external JSPromise<JSBoolean> flush();
  external int duration();
  external num getProgress();
  external int currentFrame();
  external bool videoEnabled();
  external void setVideoEnabled(bool enabled);
  external bool cacheEnabled();
  external void setCacheEnabled(bool enabled);
  external num cacheScale();
  external void setCacheScale(num value);
  external num maxFrameRate();
  external void setMaxFrameRate(num value);
  external PAGScaleMode scaleMode();
  external void setScaleMode(PAGScaleMode value);
  external void setSurface(PAGSurface? pagSurface);
  external PAGComposition getComposition();
  external void setComposition(PAGComposition? pagComposition);
  external PAGSurface getSurface();
  external Matrix matrix();
  external void setMatrix(Matrix matrix);
  external void nextFrame();
  external void preFrame();
  external bool autoClear();
  external void setAutoClear(bool value);
  external Rect getBounds(PAGLayer pagLayer);
  external VecArray getLayersUnderPoint(num localX, num localY);
  external bool hitTestPoint(
    PAGLayer pagLayer,
    num surfaceX,
    num surfaceY, [
    bool pixelHitTest,
  ]);
  external int renderingTime();
  external int imageDecodingTime();
  external int presentingTime();
  external int graphicsMemory();
  external JSPromise<JSAny?> prepare();
  external void destroy();
  external void linkVideoReader(JSObject videoReader);
  external void unlinkVideoReader(JSObject videoReader);
}

/// 播放器视图（自带播放控制与事件），对应 `pag-view.PAGView`。
extension type PAGView._(JSObject _) implements JSObject {
  external int get repeatCount;
  external set repeatCount(int value);
  external bool get isPlaying;
  external bool get isDestroyed;

  external int duration();
  external void addListener(
    PAGViewListenerEvent eventName,
    JSFunction listener,
  );
  external bool removeListener(
    PAGViewListenerEvent eventName, [
    JSFunction? listener,
  ]);
  external JSPromise<JSAny?> play();
  external void pause();
  external JSPromise<JSAny?> stop([bool notification]);
  external void setRepeatCount(int repeatCount);
  external num getProgress();
  external int currentFrame();
  external num setProgress(num progress);
  external bool videoEnabled();
  external void setVideoEnabled(bool enable);
  external bool cacheEnabled();
  external void setCacheEnabled(bool enable);
  external num cacheScale();
  external void setCacheScale(num value);
  external num maxFrameRate();
  external void setMaxFrameRate(num value);
  external PAGScaleMode scaleMode();
  external void setScaleMode(PAGScaleMode value);
  external JSPromise<JSBoolean> flush();
  external void freeCache();
  external PAGComposition getComposition();
  external void setComposition(PAGComposition pagComposition);
  external Matrix matrix();
  external void setMatrix(Matrix matrix);
  external VecArray getLayersUnderPoint(num localX, num localY);
  external void updateSize();
  external JSPromise<JSAny?> prepare();
  external JSPromise<web.ImageBitmap> makeSnapshot();
  external void destroy();
  external DebugData getDebugData();
  external void setDebugData(DebugData data);
}

/// 矩阵工具类，对应 `core_matrix.Matrix`。
extension type Matrix._(JSObject _) implements JSObject {
  external double get a;
  external set a(double value);
  external double get b;
  external set b(double value);
  external double get c;
  external set c(double value);
  external double get d;
  external set d(double value);
  external double get tx;
  external set tx(double value);
  external double get ty;
  external set ty(double value);

  external double get(MatrixIndex index);
  external void set(MatrixIndex index, double value);
  external void setAll(
    double scaleX,
    double skewX,
    double transX,
    double skewY,
    double scaleY,
    double transY, [
    double pers0,
    double pers1,
    double pers2,
  ]);
  external void setAffine(
    double a,
    double b,
    double c,
    double d,
    double tx,
    double ty,
  );
  external void reset();
  external void setTranslate(double dx, double dy);
  external void setScale(double sx, double sy, [double px, double py]);
  external void setRotate(double degrees, [double px, double py]);
  external void setSinCos(double sinV, double cosV, [double px, double py]);
  external void setSkew(double kx, double ky, [double px, double py]);
  external void setConcat(Matrix a, Matrix b);
  external void preTranslate(double dx, double dy);
  external void preScale(double sx, double sy, [double px, double py]);
  external void preRotate(double degrees, [double px, double py]);
  external void preSkew(double kx, double ky, [double px, double py]);
  external void preConcat(Matrix other);
  external void postTranslate(double dx, double dy);
  external void postScale(double sx, double sy, [double px, double py]);
  external void postRotate(double degrees, [double px, double py]);
  external void postSkew(double kx, double ky, [double px, double py]);
  external void postConcat(Matrix other);
  external void destroy();
}

/// PAGLayer 具体类型转换便捷扩展（运行时由 JS 侧保证类型）。
extension PAGLayerCastingX on PAGLayer {
  PAGTextLayer asTextLayer() => PAGTextLayer._(_);
  PAGImageLayer asImageLayer() => PAGImageLayer._(_);
  PAGSolidLayer asSolidLayer() => PAGSolidLayer._(_);
  PAGFile asFile() => PAGFile._(_);
}

// ========== types ==========

/// 时间标记，对应 `types.Marker`。
extension type Marker._(JSObject _) implements JSObject {
  factory Marker({int startTime = 0, int duration = 0, String comment = ''}) {
    final m = Marker._(JSObject());
    m.startTime = startTime;
    m.duration = duration;
    m.comment = comment;
    return m;
  }

  external int get startTime;
  external set startTime(int value);
  external int get duration;
  external set duration(int value);
  external String get comment;
  external set comment(String value);
}

/// RGB 颜色，对应 `types.Color`。
extension type Color._(JSObject _) implements JSObject {
  factory Color({int red = 0, int green = 0, int blue = 0}) {
    final c = Color._(JSObject());
    c.red = red;
    c.green = green;
    c.blue = blue;
    return c;
  }

  external int get red;
  external set red(int value);
  external int get green;
  external set green(int value);
  external int get blue;
  external set blue(int value);
}

/// 矩形区域，对应 `types.Rect`。
extension type Rect._(JSObject _) implements JSObject {
  factory Rect({num left = 0, num top = 0, num right = 0, num bottom = 0}) {
    final r = Rect._(JSObject());
    r.left = left;
    r.top = top;
    r.right = right;
    r.bottom = bottom;
    return r;
  }

  external num get left;
  external set left(num value);
  external num get top;
  external set top(num value);
  external num get right;
  external set right(num value);
  external num get bottom;
  external set bottom(num value);
}

/// 二维坐标点，对应 `types.Point`。
extension type Point._(JSObject _) implements JSObject {
  factory Point({num x = 0, num y = 0}) {
    final p = Point._(JSObject());
    p.x = x;
    p.y = y;
    return p;
  }

  external num get x;
  external set x(num value);
  external num get y;
  external set y(num value);
}

/// 视频片段范围，对应 `types.PAGVideoRange`。
extension type PAGVideoRange._(JSObject _) implements JSObject {
  external int get startTime;
  external set startTime(int value);
  external int get endTime;
  external set endTime(int value);
  external int get playDuration;
  external set playDuration(int value);
  external bool get reversed;
  external set reversed(bool value);
}

/// 文本数据，对应 `types.TextDocument`。
extension type TextDocument._(JSObject _) implements JSObject {
  external bool get applyFill;
  external set applyFill(bool value);
  external bool get applyStroke;
  external set applyStroke(bool value);
  external num get baselineShift;
  external set baselineShift(num value);
  external bool get boxText;
  external set boxText(bool value);
  external Point get boxTextPos;
  external set boxTextPos(Point value);
  external Point get boxTextSize;
  external set boxTextSize(Point value);
  external num get firstBaseLine;
  external set firstBaseLine(num value);
  external bool get fauxBold;
  external set fauxBold(bool value);
  external bool get fauxItalic;
  external set fauxItalic(bool value);
  external Color get fillColor;
  external set fillColor(Color value);
  external String get fontFamily;
  external set fontFamily(String value);
  external String get fontStyle;
  external set fontStyle(String value);
  external num get fontSize;
  external set fontSize(num value);
  external Color get strokeColor;
  external set strokeColor(Color value);
  external bool get strokeOverFill;
  external set strokeOverFill(bool value);
  external num get strokeWidth;
  external set strokeWidth(num value);
  external String get text;
  external set text(String value);
  external num get justification;
  external set justification(num value);
  external num get leading;
  external set leading(num value);
  external num get tracking;
  external set tracking(num value);
  external Color get backgroundColor;
  external set backgroundColor(Color value);
  external num get backgroundAlpha;
  external set backgroundAlpha(num value);
  external num get direction;
  external set direction(num value);
  external void delete();
}

/// PAGView 调试数据，对应 `types.DebugData`。
extension type DebugData._(JSObject _) implements JSObject {
  DebugData() : this._(JSObject());
}

/// PAGInit 初始化选项，对应 `interfaces.ModuleOption`。
extension type ModuleOption._(JSObject _) implements JSObject {
  ModuleOption() : this._(JSObject());

  /// WASM 文件定位钩子，如 `(file) => '/assets/libpag.wasm'`。
  external set locateFile(JSFunction? value);
}

/// PAGView.init 初始化选项，对应 `interfaces.PAGViewOptions`。
extension type PAGViewOptions._(JSObject _) implements JSObject {
  PAGViewOptions() : this._(JSObject());

  external set useScale(bool value);
  external set useCanvas2D(bool value);
  external set firstFrame(bool value);
}

/// 泛型容器 `types.Vector<T>`（libpag 内部集合）。
extension type Vector._(JSObject _) implements JSObject {
  external JSAny get(int index);
  @JS('push_back')
  external void pushBack(JSAny value);
  external int size();
  external void delete();
}

/// `types.VecArray`，即 `Vector<PAGLayer>` 的别名。
extension type VecArray._(JSObject _) implements JSObject {
  external JSAny get(int index);
  @JS('push_back')
  external void pushBack(JSAny value);
  external int size();
  external void delete();
}

/// 将 Vector/VecArray 转成 Dart 列表的便捷扩展。
extension VectorConversionX on Vector {
  List<T> toList<T extends JSAny?>() => [
    for (var i = 0; i < size(); i++) get(i) as T,
  ];
}

// ========== enums ==========

/// 缩放模式，对应 `PAGScaleMode`。
extension type PAGScaleMode._(int _) implements int {
  const PAGScaleMode.v(int value) : _ = value;
  static const PAGScaleMode none = PAGScaleMode.v(0);
  static const PAGScaleMode stretch = PAGScaleMode.v(1);
  static const PAGScaleMode letterBox = PAGScaleMode.v(2);
  static const PAGScaleMode zoom = PAGScaleMode.v(3);
}

/// 图层类型，对应 `LayerType`。
extension type LayerType._(int _) implements int {
  const LayerType.v(int value) : _ = value;
  static const LayerType unknown = LayerType.v(0);
  static const LayerType null_ = LayerType.v(1);
  static const LayerType solid = LayerType.v(2);
  static const LayerType text = LayerType.v(3);
  static const LayerType shape = LayerType.v(4);
  static const LayerType image = LayerType.v(5);
  static const LayerType preCompose = LayerType.v(6);
}

/// 时间伸缩模式，对应 `PAGTimeStretchMode`。
extension type PAGTimeStretchMode._(int _) implements int {
  const PAGTimeStretchMode.v(int value) : _ = value;
  static const PAGTimeStretchMode none = PAGTimeStretchMode.v(0);
  static const PAGTimeStretchMode scale = PAGTimeStretchMode.v(1);
  static const PAGTimeStretchMode repeat = PAGTimeStretchMode.v(2);
  static const PAGTimeStretchMode repeatInverted = PAGTimeStretchMode.v(3);
}

/// 矩阵元素索引，对应 `MatrixIndex`。
extension type MatrixIndex._(int _) implements int {
  const MatrixIndex.v(int value) : _ = value;
  static const MatrixIndex a = MatrixIndex.v(0);
  static const MatrixIndex c = MatrixIndex.v(1);
  static const MatrixIndex tx = MatrixIndex.v(2);
  static const MatrixIndex b = MatrixIndex.v(3);
  static const MatrixIndex d = MatrixIndex.v(4);
  static const MatrixIndex ty = MatrixIndex.v(5);
}

/// 像素颜色类型，对应 `ColorType`。
extension type ColorType._(int _) implements int {
  const ColorType.v(int value) : _ = value;
  static const ColorType unknown = ColorType.v(0);
  static const ColorType alpha8 = ColorType.v(1);
  static const ColorType rgba8888 = ColorType.v(2);
  static const ColorType bgra8888 = ColorType.v(3);
}

/// 像素 Alpha 类型，对应 `AlphaType`。
extension type AlphaType._(int _) implements int {
  const AlphaType.v(int value) : _ = value;
  static const AlphaType unknown = AlphaType.v(0);
  static const AlphaType opaque = AlphaType.v(1);
  static const AlphaType premultiplied = AlphaType.v(2);
  static const AlphaType unpremultiplied = AlphaType.v(3);
}

/// PAGView 监听事件名（字符串枚举），对应 `PAGViewListenerEvent`。
extension type PAGViewListenerEvent._(String _) implements String {
  const PAGViewListenerEvent.v(String value) : _ = value;
  static const PAGViewListenerEvent onAnimationStart = PAGViewListenerEvent.v(
    'onAnimationStart',
  );
  static const PAGViewListenerEvent onAnimationEnd = PAGViewListenerEvent.v(
    'onAnimationEnd',
  );
  static const PAGViewListenerEvent onAnimationCancel = PAGViewListenerEvent.v(
    'onAnimationCancel',
  );
  static const PAGViewListenerEvent onAnimationRepeat = PAGViewListenerEvent.v(
    'onAnimationRepeat',
  );
  static const PAGViewListenerEvent onAnimationUpdate = PAGViewListenerEvent.v(
    'onAnimationUpdate',
  );
  static const PAGViewListenerEvent onAnimationPlay = PAGViewListenerEvent.v(
    'onAnimationPlay',
  );
  static const PAGViewListenerEvent onAnimationPause = PAGViewListenerEvent.v(
    'onAnimationPause',
  );
  static const PAGViewListenerEvent onAnimationFlushed = PAGViewListenerEvent.v(
    'onAnimationFlushed',
  );
}
