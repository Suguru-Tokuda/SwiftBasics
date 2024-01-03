# Objective-C

## @interface

Objective-C has h (header) and m (implementation) files.

## .h file

We can declara public @property of the class.

## .m file

The "getter" and "setter" methods of this property are automatically generated for you behind the scene in order to make the @property's instance accessible

```
@property (weak, nonatomic) NSString *screenName; // var screenname: String
// strong: a developer manually takes care of memroy management. Default value.
@property (strong, nonatomic) NSArray *list;
@property (strong, nonatomic) UILabel *label;
@property NSMutableArray *mutableArray;
```

## @implementation

The actual implementation code comes here. You can also declare variables inside this.

```
@implementation ViewController

int value = 0;
double x = 10.1;
const float y = 20.3; // constant

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
}

- (void)viewWillAppear:(BOOL)animated {

}

- (void)setupUI {
    self.screenName = @"First screen"; // self.screenName or _screenName
    NSLog(@"screen name is %@ whos a value is %d", self.screenName, value);
    self.list = [NSArray arrayWithObjects:@[@"A", @"B", @"C"], nil];
    self.mutableArray = [NSMutableArray arrayWithObjects: @[@"Suguru"], nil];

    self.label = [[UILabel alloc] initWithFrame: CGRectMake(10, 100, 200, 40)];
    self.label.text = @"Hello World";
    self.label.textColor = UIColor.whiteColor;

    int result = [self sumOfTwoNums: 5 secondNum: 10];

    self.label.text = [[NSString alloc] initWithFormat: @"Result is: %d", result];

    [[self view] addSubview: self.label];
}

+ (void) staticFunction {

}

- (int) sumOfTwoNums: (int) num1 secondNum: (int) num2 {
    return num1 + num2;
}


- (void)doSomeHeavyTask {

}

- (void)doSomeSmallTask {

}

@end
```

## Calling a function

```
[objectName functionName];
```

## atomic vs nonatomic

`atomic` is used when the value should be accessed/modified in a thread safe manner. Otherwise, it's `nonatomic`.

## strong vs weak

`strong` and `weak` are used for memory management.

- `weak` specifies a reference that does not keep the referenced object alive.
- `strong` specifies a reference that does keep the referenced object alive.
