import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:great_places_app/providers/great_places.dart';
import 'package:great_places_app/screens/add_place_screen.dart';
import 'package:great_places_app/screens/place_detail_screen.dart';
import 'package:provider/provider.dart';

class PlacesListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Places'),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              Navigator.pushNamed(context, AddPlaceScreen.routName);
            },
          ),
        ],
      ),
      body: FutureBuilder(
        future: Provider.of<GreatePlaces>(context, listen: false)
            .fetchAndSetPlaces(),
        builder: (ctx, snapshot) => snapshot.connectionState ==
                ConnectionState.waiting
            ? Center(
                child: CircularProgressIndicator(),
              )
            : Consumer<GreatePlaces>(
                child: Center(
                  child: Text('Got no places yet, start adding some!'),
                ),
                builder: (ctx, greatePlaces, ch) => greatePlaces.items.length <=
                        0
                    ? ch
                    : ListView.builder(
                        itemCount: greatePlaces.items.length,
                        itemBuilder: (ctx, index) => ListTile(
                          leading: CircleAvatar(
                            backgroundImage:
                                FileImage(greatePlaces.items[index].image),
                          ),
                          title: Text(greatePlaces.items[index].title),
                          subtitle:
                              Text(greatePlaces.items[index].location.address),
                          onTap: () {
                            Navigator.of(context).pushNamed(
                                PlaceDetailScreen.routeName,
                                arguments: greatePlaces.items[index].id);
                          },
                        ),
                      ),
              ),
      ),
    );
  }
}
