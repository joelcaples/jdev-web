import { BrowserModule } from '@angular/platform-browser';
import { NgModule } from '@angular/core';

import { AppRoutingModule } from '../app-routing/app-routing.module';
import { AppComponent } from '../../components/app/app.component';
import { RequestQueueComponent } from '../../components/request-queue/request-queue.component';

@NgModule({
  declarations: [
    AppComponent,
    RequestQueueComponent
  ],
  imports: [
    BrowserModule,
    AppRoutingModule
  ],
  providers: [],
  bootstrap: [AppComponent]
})
export class AppModule { }
