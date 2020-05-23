import { Component, OnInit, ChangeDetectionStrategy  } from '@angular/core';
import { MainMenuItemType } from 'src/app/shared/enums/entities.enum';
import { Router } from '@angular/router';

@Component({
  selector: 'app-nav-bar',
  templateUrl: './nav-bar.component.html',
  styleUrls: ['./nav-bar.component.scss'],
  changeDetection: ChangeDetectionStrategy.OnPush
})
export class NavBarComponent implements OnInit {

  public mainMenuItem:MainMenuItemType;
  public MainMenuItemType=MainMenuItemType;

  constructor(private router:Router) { }

  ngOnInit(): void {
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
