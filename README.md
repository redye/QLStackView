# QLStackView

一个基于 UIStackView 的 DSL。

### 规则
* {} 生成一个外层 QLStackView

* 轴线方向
	* h: 水平方向
	* v: 垂直方向

* 垂直于轴线方向的对齐方式
	* t: 顶部对齐
	* l: 左对齐
	* b: 底部对齐
	* r: 右对齐
	* c: 居中

* () 表示属性
* [] 表示子视图

🌰🌰🌰🌰

```objc
UIImageView *imageView = [[UIImageView alloc] init];
imageView.backgroundColor = [UIColor blueColor];
UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
[button addTarget:self action:@selector(buttonClick) forControlEvents:UIControlEventTouchUpInside];
    
UIButton *button2 = [UIButton buttonWithType:UIButtonTypeCustom];
[button2 addTarget:self action:@selector(buttonClick) forControlEvents:UIControlEventTouchUpInside];
NSDictionary *objects = @{
                          @"imageView": imageView,
                          @"imageView2": [UIImageView new],
                          @"button": button,
                          @"button2": button2
                          };

NSString *imageViews = @"{ht(spacing:10,extendWith:0)[(width:50,height:50,backgroundColor:#ffff00)][(width:50,height:50,backgroundColor:#ffff00)][(width:50,height:50,backgroundColor:#ffff00)]}";

NSString *formatString = [NSString stringWithFormat:@"{vc(spacing:20,extendWith:2)[%@][imageView(width:50,height:50)][(text:哈哈哈哈哈哈哈,line:0,color:#ff00ff,backgroundColor:#00ff00,cornerRadius:2,padding:10)][(width:100,height:100,backgroundColor:#ff0000,button:<button>)]}", imageViews];

__weak typeof(self) weakSelf = self;
[QLStackView asyncParseFormatString:formatString
                            objects:objects
                  completionHandler:^(QLStackView * _Nonnull stackView) {
                      stackView.backgroundColor = [UIColor orangeColor];
                      [weakSelf.view addSubview:stackView];
                      [stackView mas_makeConstraints:^(MASConstraintMaker *make) {
                          make.centerX.equalTo(weakSelf.view.mas_centerX);
                          make.centerY.equalTo(weakSelf.view.mas_centerY);
                      }];
                  }];
```