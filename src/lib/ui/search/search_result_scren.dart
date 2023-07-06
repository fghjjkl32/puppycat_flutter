import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pet_mobile_social_flutter/providers/search/searchHelperProvider.dart';
import 'package:pet_mobile_social_flutter/services/search/search_db_helper.dart';

class SearchResultScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dbHelper = ref.watch(dbHelperProvider);
    final searchFuture = dbHelper.getAllSearches();

    return Scaffold(
      appBar: AppBar(title: Text('Search Result')),
      body: FutureBuilder<List<Searche>>(
        future: searchFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          final searches = snapshot.data ?? [];

          if (searches.isEmpty) {
            return Center(child: Text('No results'));
          }

          return ListView.builder(
            itemCount: searches.length,
            itemBuilder: (context, index) {
              final search = searches[index];
              return ListTile(
                title: Text(search.name),
                subtitle: Text(search.image!),
                onTap: () async {
                  print("DSA");
                  // 탭하면 검색 기록을 삭제합니다.
                  await dbHelper.deleteSearch(search);

                  // 삭제 후, 상태를 업데이트합니다.
                  ref.refresh(dbHelperProvider);
                },
              );
            },
          );
        },
      ),
    );
  }
}
