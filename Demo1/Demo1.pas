program my.mini;
(*
 * Minimalist APKPascal v0.1 sample "Hello World !" application
 *
 * (c)2017 Execute SARL <contact@execute.fr>
 *)
type
  // Should be an Interface
  CharSequence = external class(java.lang.CharSequence)
  // https://developer.android.com/reference/java/lang/CharSequence.html
  end;

  Bundle = external class(android.os.Bundle)
  // https://developer.android.com/reference/android/os/Bundle.html
  end;

  Context = external class(android.content.Context)
  // https://developer.android.com/reference/android/content/Context.html
  end;

  View = external class(android.view.View)
  // https://developer.android.com/reference/android/view/View.html
  end;

  Activity = external class(android.app.Activity, Context)
  // https://developer.android.com/reference/android/app/Activity.html
    constructor Create;
    procedure onCreate(savedInstanceState: Bundle); virtual;
    procedure setContentView(view: View); // should I prefix classes with T ?
  end;
  
  TextView = external class(android.widget.TextView, View)
  // https://developer.android.com/reference/android/widget/TextView.html
    constructor Create(context: Context);
    procedure setText(text: CharSequence);
  end;
  
  // user defined Activity
  minimal = class(Activity)
    procedure onCreate(savedInstanceState: Bundle); override;
  end;
  
procedure minimal.onCreate(SavedInstanceState: Bundle);
var
  tv: TextView;
begin
  inherited;
  tv := TextView.Create(Self);
  tv.setText('Hello World !');
  setContentView(tv);
end;

begin
// could be a {$MAIN_ACTIVITY minimal} directive, or a [MAIN] attribut...
  minimal.Create();
end.
