import { Component, OnInit } from '@angular/core';
import {MenubarModule} from 'primeng/menubar';
import {MenuItem} from 'primeng/api';
import { MainMenuItemType } from 'src/app/shared/enums/entities.enum';
import { ActivatedRoute, Route, Router } from '@angular/router';

@Component({
  selector: 'app-nav-bar',
  templateUrl: './nav-bar.component.html',
  styleUrls: ['./nav-bar.component.scss']
})
export class NavBarComponent implements OnInit {

  constructor(private router:Router) { }

  items: MenuItem[];
  public mainMenuItem:MainMenuItemType;
  public MainMenuItemType=MainMenuItemType;

  ngOnInit() {
      this.items = [
          {
              label: 'Widgets',
              items: [
                  // {
                  //     label: 'New', 
                  //     icon: 'pi pi-fw pi-plus',
                  //     items: [
                  //         {label: 'Project'},
                  //         {label: 'Other'},
                  //     ]
                  // },
                  // {label: 'Open'},
                  // {label: 'Quit'}
                  {label: 'Request Queue', routerLink:"/requestqueue"},
                  {label: 'Web Scraper', routerLink:"/webscraper"},
                  {label: 'Auto Complete Demo', routerLink:"/autocompletedemo"}
                ]
                // ,
              // command:(event) => {mainMenuItem=MainMenuItemType.Widgets}, 
            //   routerLink:"/widgetdashboard"
          },
          {separator:true},
          {
              label: 'Resources',
              icon: 'pi pi-fw pi-pencil',
              items: [
                  // {label: 'Delete', icon: 'pi pi-fw pi-trash'},
                  // {label: 'Refresh', icon: 'pi pi-fw pi-refresh'}
              ],
              routerLink:"/resources"
          },
          {separator:true},
          {
              label: 'Tech',
              icon: 'pi pi-fw pi-pencil',
              items: [
              ],
              routerLink:"/tech"
          },
          {separator:true},
          {
              label: 'Comics',
              icon: 'pi pi-fw pi-pencil',
              items: [
              ],
              routerLink:"/comics"
          }


      ];
  }

  public getCurrentRoute() {
    switch(this.router.url) {
      case '/widgetdashboard':
      case '/requestqueue':
      case '/webscraper':
      case '/autocompletedemo':
        return MainMenuItemType.Widgets;
      default:
        return MainMenuItemType.Undefined;
    }
}

}
