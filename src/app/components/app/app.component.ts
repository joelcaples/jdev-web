import { Component } from '@angular/core';
import { MainMenuItemType } from 'src/app/shared/enums/entities.enum';

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
}
