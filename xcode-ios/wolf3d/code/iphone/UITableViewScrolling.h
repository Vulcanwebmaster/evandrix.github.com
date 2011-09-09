/*
 
 Copyright (C) 2009-2011 id Software LLC, a ZeniMax Media company. 

 This file is part of the WOLF3D iOS v2.1 GPL Source Code. 

 
 This program is free software; you can redistribute it and/or
 modify it under the terms of the GNU General Public License
 as published by the Free Software Foundation; either version 2
 of the License, or (at your option) any later version.
 
 This program is distributed in the hope that it will be useful,
 but WITHOUT ANY WARRANTY; without even the implied warranty of
 MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 GNU General Public License for more details.
 
 You should have received a copy of the GNU General Public License
 along with this program; if not, write to the Free Software
 Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA  02111-1307, USA.
 
 */

#ifndef UITABLEVIEWSCROLLING_H
#define UITABLEVIEWSCROLLING_H


@class UITableView;

void UITableViewScrollingPageUp( UITableView * table, int totalRows );
void UITableViewScrollingPageDown( UITableView * table, int totalRows );
void UITableViewScrollingScrollToRow( UITableView * table, int row, int maxRow );


#endif
