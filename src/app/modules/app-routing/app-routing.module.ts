import { NgModule } from '@angular/core';
import { Routes, RouterModule } from '@angular/router';

import { PortletComponent }   from '../../components/portlet/portlet.component';


const routes: Routes = [
  { path: '', redirectTo: '/portlet', pathMatch: 'full' },
  { path: 'portlet', component: PortletComponent }
];

@NgModule({
  imports: [RouterModule.forRoot(routes)],
  exports: [RouterModule]
})
export class AppRoutingModule { }
