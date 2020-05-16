import { Component } from '@angular/core';
import { MainMenuItemType } from 'src/app/shared/enums/entities.enum';
import { ActivatedRoute, Route, Router } from '@angular/router';

@Component({
  selector: 'app-root',
  templateUrl: './app.component.html',
  styleUrls: ['./app.component.scss']
})
export class AppComponent {
  title = 'jdev-web';
  //public pageMode:number=0;
  public mainMenuItem:MainMenuItemType;
  public MainMenuItemType=MainMenuItemType;

  constructor(private router:Router) {
    
  }

  public getCurrentRoute() {
      switch(this.router.url) {
        case '/widgetdashboard':
        case '/requestqueue':
        case '/webscraper':
              return MainMenuItemType.Widgets;
        default:
          return MainMenuItemType.Undefined;
      }
  }
}
